#import <Foundation/Foundation.h>

__attribute__((constructor))
void LSTInitializeVM()
{
	NSLog(@"Initializing VM...");
}

@interface $Object : NSObject {
@public
	BOOL _latteObject;
}
- $lattelize;
- (void)hello;
@end

@implementation $Object
- $lattelize
{
	_latteObject = YES;
	return self;
}
- (void)hello
{
	NSLog(@"Hello");
}
@end

BOOL ObjectIsLatteObject(id object) {
	return (($Object *)object)->_latteObject;
}

int main(int argc, char *argv[])
{
	@autoreleasepool {
		$Object *o = [[$Object new] $lattelize];
		[o hello];

		id nso = [[NSString alloc] initWithString:@"Hello"]; 
		NSLog(@"%d %d", ObjectIsLatteObject(o), ObjectIsLatteObject(nso));
	}
	return 0;
}

