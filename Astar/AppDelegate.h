#ifndef _APPDELEGATE_
#define _APPDELEGATE_

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <AppKit/AppKit.h>
#import "NewView.h"
#import "BufferObject.h"
#import "Outputs.h"
#import "Creep.h"
#import "Grid.h"
#import "InputHandler.h"
#import "Astar.h"
#import "structs.h"
#import "LoopTimer.h"

@interface AppDelegate: NSObject <NSApplicationDelegate> {
	//NSWindow *window;
	//NSWindowController *windowController;
	NewView *view;
	//NSOpenGLContext *context;
	BufferObject *buffer;
	Outputter *outputter;
	InputHandler *inputHandler;
	Grid *grid;
	Creep **creep;
	Astar *astar;
	bool astarRunning;
	LoopTimer *loopTimer;
	}

@property (assign) NSWindow *window;
@property (assign) NSWindowController *windowController;
@property (assign) NSOpenGLContext *context;

-(void)initWindow;
-(void)initOpenGL;

-(void)mainLoop;

-(bool)applicationShouldTerminateAfterLastWindowClosed: (NSApplication*) application;

-(void)loadGame;

-(void)update;
-(void)doLogic;
-(void)render;

-(void)updateMouseLocation;

-(void)sampleFPS;

-(void)drawWindow;
-(void)clearMainView;
-(void)clearWindow;

-(void)updateInputs;

//Input events: forwarded from NewView to InputHandler
-(void)leftMouseDown;
-(void)leftMouseUp;
-(void)rightMouseDown;
-(void)rightMouseUp;
-(void)keyDown: (unsigned short)code;
-(void)keyUp: (unsigned short) code;

@end

#endif
