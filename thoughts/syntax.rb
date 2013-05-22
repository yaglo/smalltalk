package Compiler-IR.

NodeVisitor < IRASTTranslator {
    
    "I am the AST (abstract syntax tree) visitor responsible for building the intermediate representation graph."
    
    | @source @theClass @method @sequence @nextAlias ClassVariable *PoolDictionary |
    
    "accessing"
    
    - nextAlias {
	    nextAlias ifNil: [ nextAlias := 0 ].
	    nextAlias := nextAlias + 1.
	    ^ nextAlias asString
    }
    
    - withSequence: aSequence do: aBlock {
    	| outerSequence |
    	outerSequence := self sequence.
    	self sequence: aSequence.
    	aBlock value.
    	self sequence: outerSequence.
    	^ aSequence
    }
    
    "visiting"
    
    - alias: aNode {
    	| variable |

    	aNode isImmutable ifTrue: [ ^ self visit: aNode ].

    	variable := IRVariable new
    		variable: (AliasVar new name: '$', self nextAlias);
    		yourself.

    	self sequence add: (IRAssignment new
    		add: variable;
    		add: (self visit: aNode);
    		yourself).

    	self method internalVariables add: variable.

    	^ variable
    }

    - aliasTemporally: aCollection {
    	"https://github.com/NicolasPetton/amber/issues/296
	
    	If a node is aliased, all preceding ones are aliased as well.
    	The tree is iterated twice. First we get the aliasing dependency,
    	then the aliasing itself is done"

    	| threshold result |
    	threshold := 0.
	
    	aCollection withIndexDo: [ :each :i |
    		each subtreeNeedsAliasing
    			ifTrue: [ threshold := i ]].

    	result := OrderedCollection new.
    	aCollection withIndexDo: [ :each :i |
    		result add: (i <= threshold
    			ifTrue: [ self alias: each ]
    			ifFalse: [ self visit: each ])].

    	^result
    }

    - visitAssignmentNode: aNode {
    	| left right assignment |
    	right := self visit: aNode right.
    	left := self visit: aNode left.
    	self sequence add: (IRAssignment new
    		add: left;
    		add: right;
    		yourself).
    	^ left
    }

    - visitBlockNode: aNode {
    	| closure |
    	closure := IRClosure new
    		arguments: aNode parameters;
    		scope: aNode scope;
    		yourself.
    	aNode scope temps do: [ :each |
    		closure add: (IRTempDeclaration new
    			name: each name;
    			scope: aNode scope;
    			yourself) ].
    	aNode nodes do: [ :each | closure add: (self visit: each) ].
    	^ closure
    }

    - visitBlockSequenceNode: aNode {
    	^ self
    		withSequence: IRBlockSequence new
    		do: [
    			aNode nodes ifNotEmpty: [
    				aNode nodes allButLast do: [ :each |
    					self sequence add: (self visit: each) ].
    				aNode nodes last isReturnNode
    					ifFalse: [ self sequence add: (IRBlockReturn new add: (self visit: aNode nodes last); yourself) ]
    					ifTrue: [ self sequence add: (self visit: aNode nodes last) ]]]
    }

    - visitCascadeNode: aNode {
    	| alias |

    	aNode receiver isImmutable ifFalse: [
    		alias := self alias: aNode receiver.
    		aNode nodes do: [ :each |
    			each receiver: (VariableNode new binding: alias variable) ]].

    	aNode nodes allButLast do: [ :each |
    		self sequence add: (self visit: each) ].

    	^ self alias: aNode nodes last
    }

    - visitDynamicArrayNode: aNode {
    	| array |
    	array := IRDynamicArray new.
    	(self aliasTemporally: aNode nodes) do: [:each | array add: each].
    	^ array
    }

    - visitDynamicDictionaryNode: aNode {
    	| dictionary |
    	dictionary := IRDynamicDictionary new.
    	(self aliasTemporally: aNode nodes) do: [:each | dictionary add: each].
    	^ dictionary
    }

    - visitJSStatementNode: aNode {
    	^ IRVerbatim new
    		source: aNode source crlfSanitized;
    		yourself
    }

    - visitMethodNode: aNode {

    	self method: (IRMethod new
    		source: self source crlfSanitized;
    		theClass: self theClass;
    		arguments: aNode arguments;
    		selector: aNode selector;
    		messageSends: aNode messageSends;
    		superSends: aNode superSends;
    		classReferences: aNode classReferences;
    		scope: aNode scope;
    		yourself).

    	aNode scope temps do: [ :each |
    		self method add: (IRTempDeclaration new
    			name: each name;
    			scope: aNode scope;
    			yourself) ].

    	aNode nodes do: [ :each | self method add: (self visit: each) ].

    	aNode scope hasLocalReturn ifFalse: [
    		(self method add: IRReturn new) add: (IRVariable new
    			variable: (aNode scope pseudoVars at: 'self');
    			yourself) ].

    	^ self method
    }

    - visitReturnNode: aNode {
    	| return |
    	return := aNode nonLocalReturn
    		ifTrue: [ IRNonLocalReturn new ]
    		ifFalse: [ IRReturn new ].
    	return scope: aNode scope.
    	aNode nodes do: [ :each |
    		return add: (self alias: each) ].
    	^ return
    }

    - visitSendNode: aNode {
    	| send all receiver arguments |
    	send := IRSend new.
    	send
    		selector: aNode selector;
    		index: aNode index.
    	aNode superSend ifTrue: [ send classSend: self theClass superclass ].
	
    	all := self aliasTemporally: { aNode receiver }, aNode arguments.
    	receiver := all first.
    	arguments := all allButFirst.

    	send add: receiver.
    	arguments do: [ :each | send add: each ].

    	^ send
    }

    - visitSequenceNode: aNode {
    	^ self
    		withSequence: IRSequence new
    		do: [
    			aNode nodes do: [ :each | | instruction |
    				instruction := self visit: each.
    				instruction isVariable ifFalse: [
    					self sequence add: instruction ]]]
    }

    - visitValueNode: aNode {
    	^ IRValue new
    		value: aNode value;
    		yourself
    }

    - visitVariableNode: aNode {
    	^ IRVariable new
    		variable: aNode binding;
    		yourself
    }
}