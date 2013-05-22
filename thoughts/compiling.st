process: anObject
	anObject = #print "операция print выводит верхнее число в стеке"
		ifTrue: [^Transcript show: stack removeLast; cr].

	anObject = #drop "операция drop верхнее число из стека"
		ifTrue: [^stack removeLast].

	anObject = #dup "операция dup дублирует верхнее число в стеке"
		ifTrue: [
			| number |
			number := stack removeLast.
			^stack
				add: number;
				add: number].

	anObject isNumber
		ifTrue: [stack add: anObject] "если попалось число, просто добавляем его в стек"
		ifFalse: [
			| result operation left right |
			right := stack removeLast. "берем правый операнд из стека, это 2 в выражении 1 - 2"
			left := stack removeLast. "берем левый операнд из стека, это 1 в выражении 1 - 2"
			operation := (operations at: anObject). "выбираем операцию из словаря операций"
			result := operation value: left value: right. "выполняем операцию (блок) с двумя операндами (в блоке это :x и :y)"
			stack add: result "кладем результат обратно в стек"]






anObject = #print "операция print выводит верхнее число в стеке"
	ifTrue: [^Transcript show: stack removeLast; cr].

61 <10> pushTemp: 0			"push anObject (first argument)"
62 <24> pushConstant: #print		"push #print (constant symbol)"
63 <B6> send: =					"send ="
64 <9F> jumpFalse: 73			"jump on false to #drop comparison"
65 <40> pushLit: Transcript		"push Transcript (global literal)"
66 <88> dup						"duplicate top"
67 <00> pushRcvr: 0				"push stack (first receiver variable)"
68 <D2> send: removeLast			"send removeLast, the return value becomes the argument for show:"
69 <E1> send: show:				"send show:"
70 <87> pop						"pop return value from show:, we don't need it"
71 <D3> send: cr					"send cr"
72 <7C> returnTop				"return stack top value"



anObject = #drop "операция drop верхнее число из стека"
	ifTrue: [^stack removeLast].


73 <10> pushTemp: 0
74 <25> pushConstant: #drop
75 <B6> send: =
76 <9A> jumpFalse: 80
77 <00> pushRcvr: 0
78 <D2> send: removeLast
79 <7C> returnTop
80 <10> pushTemp: 0
81 <27> pushConstant: #dup
82 <B6> send: =
83 <AC 0B> jumpFalse: 96
85 <00> pushRcvr: 0
86 <D2> send: removeLast
87 <69> popIntoTemp: 1
88 <00> pushRcvr: 0
89 <88> dup
90 <11> pushTemp: 1
91 <E6> send: add:
92 <87> pop
93 <11> pushTemp: 1
94 <E6> send: add:
95 <7C> returnTop









anObject isNumber
	ifTrue: [stack add: anObject] "если попалось число, просто добавляем его в стек"
	ifFalse: [
		| result operation left right |
		right := stack removeLast. "берем правый операнд из стека, это 2 в выражении 1 - 2"
		left := stack removeLast. "берем левый операнд из стека, это 1 в выражении 1 - 2"
		operation := (operations at: anObject). "выбираем операцию из словаря операций"
		result := operation value: left value: right. "выполняем операцию (блок) с двумя операндами (в блоке это :x и :y)"
		stack add: result "кладем результат обратно в стек"]




(send (send $anObject #isNumber) #ifTrue:#ifFalse (block (send $stack #add: $anObject)
												  (block (assign $right (send $stack #removeLast)
													     (assign $left (send $stack #removeLast)
													     (assign $operation (send $operations #at: $anObject)
													     (assign $result (send $operation #value:value: $left $right)
													     (send $stack #add: $result))


(if (send $anObject #isNumber) (block ((send $stack #add: $anObject))
							   (block ((assign $right (send $stack #removeLast)
							 	       (assign $left (send $stack #removeLast)
							 	       (assign $operation (send $operations #at: $anObject)
							 	       (assign $result (send $operation #value:value: $left $right)
							 	       (send $stack #add: $result)))


	pushTemp: anObject
	send: isNumber
	jumpFalse: _false_1
_true_1:
	pushRcvr: stack
	pushTemp: anObject
	send: add:
	jumpTo: _end
_false_1:
	pushRcvr: stack
	send: removeLast
	popIntoTemp: right
	pushRcvr: stack
	send: removeLast
	popIntoTemp: left
	pushRcvr: operations
	pushTemp: anObject
	send: at:
	popIntoTemp: operation
	pushTemp: operation
	pushTemp: left
	pushTemp: right
	send: value:value:
	popIntoTemp: result
	pushRcvr: stack
	pushTemp: result
	send: add:
_end:
	pop





96 <10> pushTemp: 0
97 <D9> send: isNumber
98 <9C> jumpFalse: 104

99 <00> pushRcvr: 0
100 <10> pushTemp: 0
101 <E6> send: add:
102 <A4 12> jumpTo: 122

104 <00> pushRcvr: 0
105 <D2> send: removeLast
106 <6D> popIntoTemp: 5
107 <00> pushRcvr: 0
108 <D2> send: removeLast
109 <6C> popIntoTemp: 4
110 <01> pushRcvr: 1
111 <10> pushTemp: 0
112 <C0> send: at:
113 <6B> popIntoTemp: 3
114 <13> pushTemp: 3
115 <14> pushTemp: 4
116 <15> pushTemp: 5
117 <F8> send: value:value:
118 <6A> popIntoTemp: 2
119 <00> pushRcvr: 0
120 <12> pushTemp: 2
121 <E6> send: add:
122 <87> pop






123 <78> returnSelf







bottomContext
	^ self findContextSuchThat: [:c | c sender isNil]

(return (send self #findContextSuchThat: (block ($c) ((send (send $c #sender) #isNil)))))

25 <70> self
26 <8F 01 00 04> closureNumCopied: 0 numArgs: 1 bytes 30 to 33
30 	<10> pushTemp: 0
31 	<D2> send: sender
32 	<D1> send: isNil
33 	<7D> blockReturn
34 <E0> send: findContextSuchThat:
35 <7C> returnTop








findSecondToOldestSimilarSender
	"Search the stack for the second-to-oldest occurance of self's method.  Very useful for an infinite recursion.  Gets back to the second call so you can see one complete recursion cycle, and how it was called at the beginning."

	| sec ctxt bot |
	sec := self.
	ctxt := self.
	[	bot := ctxt findSimilarSender.
		bot isNil
	] whileFalse: [
		sec := ctxt.
		ctxt := bot.
	].
	^ sec


(context ($sec $ctxt $bot)
  (assign $sec self)
  (assign $ctxt self)
  (send
    (block (assign $bot (send $ctxt #findSimilarSender))
	       (send $bot #isNil))
	#whileFalse:
	(block (assign $sec $ctxt)
	       (assign $ctxt $bot)))
  (return $sec))




(assign $0 self)
(assign $1 self)
(send
  (block (assign $2 (send $1 #findSimilarSender))
         (send $2 #isNil))
  #whileFalse:
  (block (assign $0 $1)
         (assign $1 $2)))
(return $0)



(assign var value) => (push value) (pop-into var)
(send receiver message arguments) => (push receiver) (push arguments) (send message)
(block ....) => (....) (block-return)



(push self)
(pop-into $0)
(push self)
(pop-into $1)
(block (push $1)
	   (send #findSimilarSender)
	   (pop-into $2)
	   (push $2)
	   (send #isNil)
	   (block-return))
(block (push $1)
       (pop-into $0)
	   (push $2)
	   (pop-into $1)
	   (block-return))
(send #whileFalse:)
(push $0)
(return-top)




	25 <70> self
	26 <68> popIntoTemp: 0
	27 <70> self
	28 <69> popIntoTemp: 1
	29 <11> pushTemp: 1
	30 <D0> send: findSimilarSender
	31 <6A> popIntoTemp: 2
	32 <12> pushTemp: 2
	33 <D1> send: isNil
	34 <A8 06> jumpTrue: 42
	36 <11> pushTemp: 1
	37 <68> popIntoTemp: 0
	38 <12> pushTemp: 2
	39 <69> popIntoTemp: 1
	40 <A3 F3> jumpTo: 29
	42 <10> pushTemp: 0
	43 <7C> returnTop



















loadPatch
	| old new |
	(self zip memberNamed: 'patch.bin') ifNotNil:
		[:m | [^ patch := (MCDataStream on: m contentStream) next ]
			on: Error do: [:fallThrough ]].
	definitions := OrderedCollection new.
	(self zip membersMatching: 'old/*')
		do: [:m | self extractDefinitionsFrom: m].
	old := definitions asArray.
	definitions := OrderedCollection new.
	(self zip membersMatching: 'new/*')
		do: [:m | self extractDefinitionsFrom: m].
	new := definitions asArray.
	^ patch := self buildPatchFrom: old to: new.
	





