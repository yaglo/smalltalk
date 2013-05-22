#import <Foundation/Foundation.h>

id True, False;

typedef id (^block_t)();

@class StAssociation;

@interface StObject : NSObject
@end

@implementation StObject
{
	NSMutableDictionary *_container;
}

- init {
	self = [super init];
	if (self) {
		_container = [[NSMutableDictionary alloc] init];
	}
	return self;
}

+ basicNew {
	return [[self alloc] init];
}

- species {
	return [self class];
}

- __eq__: anObject {
	return self == anObject ? True : False;
}

+ __eq__: anObject {
	return self == anObject ? True : False;
}

#pragma mark - accessing

- at: index {
	return [_container objectForKey: index];
}

- at: index modify: (block_t)aBlock {
	/* Replace the element of the collection with itself transformed by the block */
	return [self at: index put: aBlock([self at: index])];
}

- at: index put: value {
	[_container setObject: value forKey: index];
	return value;
}

- basicAt: index {
	return [_container objectForKey: index];
}

- basicAt: index put: value {
	[_container setObject: value forKey: index];
	return value;
}

- basicSize {
	return [NSNumber numberWithUnsignedInteger:[_container count]];
}

- enclosedSetElement {
	/* The receiver is included into a set as an element. 
	Since some objects require wrappers (see SetElement) to be able to be included into a Set,
	a set sends this message to its element to make sure it getting real object,
	instead of its wrapper.
	Only SetElement instance or its subclasses allowed to answer something different than receiver itself */
	
	return self;
}

- ifNil: nilBlock ifNotNilDo: (block_t)aBlock {
	/* Evaluate aBlock with the receiver as its argument. */

	return aBlock(self);
}

- ifNotNilDo: (block_t)aBlock {
	/* Evaluate the given block with the receiver as its argument. */

	return aBlock(self);
}

- ifNotNilDo: (block_t)aBlock ifNil: (block_t)nilBlock {
	/* Evaluate aBlock with the receiver as its argument. */

	return aBlock(self);
}

- in: (block_t)aBlock {
	/* Evaluate the given block with the receiver as its argument. */

	return aBlock(self);
}

- readFromString: aString {
	/* Create an object based on the contents of aString. */
	return [self readFrom: [aString readStream]];
}

- size {
	return [NSNumber numberWithUnsignedInteger:[_container count]];
}

- yourself {
	return self;
}

#pragma mark - associating

- __dash_gt__: anObject {
	/* Answer an Association between self and anObject */
	
	return [[StAssociation basicNew] key: self value: anObject];
}

#pragma mark - binding

- bindingOf: aString {
	return nil;
}

#pragma mark - casing

- caseOf: aBlockAssociationCollection {
	/* The elements of aBlockAssociationCollection are associations between blocks.
	 Answer the evaluated value of the first association in aBlockAssociationCollection
	 whose evaluated key equals the receiver.  If no match is found, report an error. */

	return [self caseOf: aBlockAssociationCollection otherwise: ^{ return [self caseError]; }];

// "| z | z := {[#a]->[1+1]. ['b' asSymbol]->[2+2]. [#c]->[3+3]}. #b caseOf: z"
// "| z | z := {[#a]->[1+1]. ['d' asSymbol]->[2+2]. [#c]->[3+3]}. #b caseOf: z"
// "The following are compiled in-line:"
// "#b caseOf: {[#a]->[1+1]. ['b' asSymbol]->[2+2]. [#c]->[3+3]}"
// "#b caseOf: {[#a]->[1+1]. ['d' asSymbol]->[2+2]. [#c]->[3+3]}"
}

- caseOf: aBlockAssociationCollection otherwise: aBlock {
	/* The elements of aBlockAssociationCollection are associations between blocks.
	 Answer the evaluated value of the first association in aBlockAssociationCollection
	 whose evaluated key equals the receiver.  If no match is found, answer the result
	 of evaluating aBlock. */

	[aBlockAssociationCollection associationsDo:
		^(id assoc){ [[[[assoc key] value] __eq__: self] ifTrue: ^{ return [[assoc value] value]; }]; }];
	return [aBlock value];

// "| z | z := {[#a]->[1+1]. ['b' asSymbol]->[2+2]. [#c]->[3+3]}. #b caseOf: z otherwise: [0]"
// "| z | z := {[#a]->[1+1]. ['d' asSymbol]->[2+2]. [#c]->[3+3]}. #b caseOf: z otherwise: [0]"
// "The following are compiled in-line:"
// "#b caseOf: {[#a]->[1+1]. ['b' asSymbol]->[2+2]. [#c]->[3+3]} otherwise: [0]"
// "#b caseOf: {[#a]->[1+1]. ['d' asSymbol]->[2+2]. [#c]->[3+3]} otherwise: [0]"
}

- subclassResponsibility {
	assert(false);
	return self;
}

@end

@interface StBoolean : StObject
@end

@implementation StBoolean
@end

@interface StTrue : StBoolean
@end

@implementation StTrue

- ifTrue: (block_t)aBlock {
	return aBlock();
}

- ifFalse: (block_t)aBlock {
	return nil;
}

- ifTrue: (block_t)trueAlternativeBlock ifFalse: (block_t)falseAlternativeBlock {
	return trueAlternativeBlock();
}

- and: (block_t)aBlock {
	return aBlock();
}

- not {
	return False; // checkme
}

@end

@interface StFalse : StBoolean
@end

@implementation StFalse

- ifTrue: (block_t)aBlock {
	return nil;
}

- ifFalse: (block_t)aBlock {
	return aBlock();
}

- ifTrue: (block_t)trueAlternativeBlock ifFalse: (block_t)falseAlternativeBlock {
	return falseAlternativeBlock();
}

- and: (block_t)aBlock {
	return self;
}

- not {
	return True; // checkme
}

@end

@interface StMagnitude : StObject
@end

@implementation StMagnitude

#pragma mark - comparing

- max: aMagnitude {
	/* Answer the receiver or the argument, whichever has the greater 
	magnitude.*/

	return [[self __gt__: aMagnitude]
		ifTrue: ^{ return self; }
		ifFalse: ^{ return aMagnitude; }];
}

- min: aMagnitude {
	/* Answer the receiver or the argument, whichever has the lesser 
	magnitude.*/

	return [[self __lt__: aMagnitude]
		ifTrue: ^{ return self; }
		ifFalse: ^{ return aMagnitude; }];
}

- min: aMin max: aMax {
	return [[self min: aMin] max: aMax];
}

#pragma mark - hash

- hash {
	/* Hash must be redefined whenever = is redefined. */

	return [self subclassResponsibility];
}

#pragma mark - testing

- __lt__: aMagnitude {
	/* Answer whether the receiver is less than the argument. */

	return [self subclassResponsibility];
}

- __le__: aMagnitude {
	/* Answer whether the receiver is less than or equal to the argument. */

	return [[self __ge__: aMagnitude] not];
}

- __eq__: aMagnitude {
	/* Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false. */

	return [self subclassResponsibility];
}

- __gt__: aMagnitude {
	/* Answer whether the receiver is greater than the argument. */

	return [aMagnitude __lt__: self];
}

- __ge__: aMagnitude {
	/* Answer whether the receiver is greater than or equal to the argument. */

	return [aMagnitude __le__: self];
}

- between: min and: max {
	/* Answer whether the receiver is less than or equal to the argument, max, 
	and greater than or equal to the argument, min. */

	return [[self __ge__: min] and: ^{ return [self __le__: max]; }];
}

@end

@interface StLookupKey : StMagnitude
{
	id key;
}
@end

@implementation StLookupKey

#pragma mark - accessing

- canAssign {
	return True;
}

- key
{
	return key;
}

- key: anObject
{
	/* Store the argument, anObject, as the lookup key of the receiver. */

	key = anObject;
	return self;
}

- name {
	return [[[self key] isString]
		ifTrue: ^{ return [self key]; }
		ifFalse: ^{ return [[self key] printString]; }];
}

#pragma mark - comparing

- __lt__: aLookupKey {
	/* Refer to the comment in Magnitude|<. */

	return [key __lt__: [aLookupKey key]];
}

- __eq__: aLookupKey {
	return [[[self species] __eq__: [aLookupKey species]]
		ifTrue: ^{ return [key __eq__: [aLookupKey key]]; }
		ifFalse: ^{ return False; }];
}

- hash {
	return [key hash];
}

#pragma mark - printing

- printOn: aStream {
	[key printOn: aStream];
	return self;
}

#pragma mark - testing

- isSpecialReadBinding {
	/* Return true if this variable binding is read protected, e.g., should not
	be accessed primitively but rather by sending #value messages */
	return False;
}

- isVariableBinding {
	/* Return true if I represent a literal variable binding */
	return True;
}

#pragma mark + instance creation

+ key: aKey {
	/* Answer an instance of me with the argument as the lookup up. */

	return [[self basicNew] key: aKey];
}
	
@end

@interface StAssociation : StLookupKey
{
	id value;
}
@end

@implementation StAssociation

#pragma mark - accessing

- key: aKey value: anObject {
	/* Store the arguments as the variables of the receiver. */

	key = aKey;
	value = anObject;
	return self;
}

- value {
	/* Answer the value of the receiver. */

	return value;
}

- value: anObject {
	/* Store the argument, anObject, as the value of the receiver. */

	value = anObject;
	return self;
}

#pragma mark - comparing

- __eq__: anAssociation {
	return [[super __eq__: anAssociation] and: ^{ return [value __eq__: [anAssociation value]]; }];
}

#pragma mark - printing

- printOn: aStream {
	[super printOn: aStream];
	[aStream nextPutAll: @"->"];
	[value printOn: aStream];
	return self;
}

- storeOn: aStream {
	/* Store in the format (key->value) */
//	[aStream nextPut: [Character fromC: '(']];
//	[key storeOn: aStream];
//	[aStream nextPutAll: @"->"];
//	[value storeOn: aStream];
//	[aStream nextPut: [Character fromC: ')']];
	return self;
}

#pragma mark - self evaluating

- isSelfEvaluating {
	return [[[self class] __eqeq__: [StAssociation class]] and: ^{ return [[[self key] isSelfEvaluating] and: ^{ return [[self value] isSelfEvaluating]; }]; }];
}

#pragma mark - testing

- literalEqual: otherLiteral {
	/* Answer true if the receiver and otherLiteral represent the same literal.
	Variable bindings are literally equals only if identical.
	This is how variable sharing works, by preserving identity and changing only the value. */
	return [self __eqeq__: otherLiteral];
}

#pragma mark + instance creation

+ key: newKey value: newValue {
	/* Answer an instance of me with the arguments as the key and value of 
	the association. */

	return [[super key: newKey] value: newValue];
}

@end

int main(int argc, char *argv[]) {
	@autoreleasepool {
		True = [StTrue new];
		False = [StFalse new];

		StObject *key1 = [StObject new];
		StObject *key2 = [StObject new];
	
		StAssociation *assoc1 = [key1 __dash_gt__: @"Hello"];
		StAssociation *assoc2 = [key2 __dash_gt__: @"World"];
	
		[[assoc1 __eq__: assoc2]
			ifTrue: (block_t)^{ NSLog(@"Equal!"); }
			ifFalse: (block_t)^{ NSLog(@"Not equal!"); }
		];
	}
	return 0;
}