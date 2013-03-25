#import "NewView.h"
#import "AppDelegate.h"

@implementation NewView

//This method apparently unnecessary? leaving it here anyway.
-(bool)acceptsFirstMouse: (NSEvent*)theEvent{
	return YES;
	}

-(void)setDelegate: (AppDelegate*)del{
	delegate = del;
	}

-(void)keyDown: (NSEvent*)theEvent{
	[delegate keyDown: [theEvent keyCode]];
	}

-(void)keyUp: (NSEvent*)theEvent{
	[delegate keyUp: [theEvent keyCode]];
	}

-(void)mouseDown: (NSEvent*)theEvent{
	[delegate leftMouseDown];
	}

-(void)mouseUp: (NSEvent*)theEvent{
	[delegate leftMouseUp];
	}

-(void)rightMouseDown: (NSEvent*)theEvent{
	[delegate rightMouseDown];
	}

-(void)rightMouseUp: (NSEvent*)theEvent{
	[delegate rightMouseUp];
	}

@end
