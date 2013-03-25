#ifndef _NEWVIEW_
#define _NEWVIEW_

#import <Cocoa/Cocoa.h>

@class AppDelegate;

@interface NewView: NSView {
	AppDelegate *delegate;
	}

-(bool)acceptsFirstMouse: (NSEvent*)theEvent;

-(void)setDelegate: (AppDelegate*)del;

-(void)mouseDown: (NSEvent*)theEvent;
-(void)mouseUp: (NSEvent*)theEvent;
-(void)keyDown: (NSEvent*)theEvent;
-(void)keyUp: (NSEvent*)theEvent;

@end

#endif
