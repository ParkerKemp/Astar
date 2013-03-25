#import "AppDelegate.h"
#import <stdio.h>
#import <sys/time.h>


//debugging
//long int last;

@implementation AppDelegate

@synthesize window, windowController, context;

-(void)applicationDidFinishLaunching: (NSNotification*)aNotification{
	printf("Launch successful!\n");
	[self initWindow];
	[self initOpenGL];
	[self loadGame];

	//[self performSelector: @selector(mainLoop) withObject: nil];

	[NSTimer scheduledTimerWithTimeInterval: 0 target: self selector: @selector(update) userInfo:nil repeats:YES];
	}

-(void)mainLoop{
	int temp = 1;

	while(temp == 1){
		while(!loopTimer->readyToFire())
			;
		if(true)
			temp = 1;
		[self update];
		}	
	}

-(void)initWindow{
	NSRect rect = NSMakeRect(200, 200, windowWidth, windowHeight);
	window = [[[NSWindow alloc] initWithContentRect:rect styleMask:NSTitledWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask backing:NSBackingStoreBuffered defer:NO] autorelease];
	[window makeKeyAndOrderFront: NSApp];
	windowController = [[NSWindowController alloc] initWithWindow: window];
	[windowController showWindow: nil];
	view = [[NewView alloc] init];
	[view setDelegate: self];
	[window setContentView: view];
	[window makeFirstResponder: view];
	}

-(void)initOpenGL{
	NSOpenGLPixelFormatAttribute attributes[] = {NSOpenGLPFADoubleBuffer, 0};
	NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes: attributes];
	self.context = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:nil];
	[self.context setView:[self.window contentView]];
	[self.context makeCurrentContext];

	//Disable Vsync (currently unused, i.e. Vsync is enabled)
	//int temp = 0;
	//[self.context setValues: &temp forParameter: NSOpenGLCPSwapInterval];	

	glViewport(0, 0, windowWidth, windowHeight);
	glMatrixMode(GL_PROJECTION);
	glOrtho(0, windowWidth, 0, windowHeight, -1, 100);
	
	//Flip all textures right side up
	glMatrixMode(GL_TEXTURE);
	glLoadIdentity();
	glScalef(1.0f, -1.0f, 1.0f);

	glMatrixMode(GL_MODELVIEW);

	glEnable(GL_SCISSOR_TEST);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	}

-(bool)applicationShouldTerminateAfterLastWindowClosed: (NSApplication*)application{
	return YES;
	}

-(void)loadGame{
	inputHandler = new InputHandler;
	loopTimer = new LoopTimer(1000.0f / framerate);
	
	//Initialize buffer, load font
	buffer = new BufferObject(gridWidth * gridHeight * 6 + 10, (gridWidth + gridHeight) * 2);
	buffer->loadFont(absolutePath("ArialGL.glf"));
	outputter = new Outputter(buffer);
	grid = new Grid(gridWidth, gridHeight, buffer, inputHandler);

	astarRunning = false;
	astar = new Astar(grid, buffer);
	astar->setStart((location){5, 5});
	astar->setDestination((location){10, 10});
	creep = new Creep*[10];
	for(int a = 0; a < 10; a++){
		creep[a] = new Creep(buffer, grid);
		creep[a]->initRandom();
		}
	}

-(void)update{
//	[self sampleFPS];

	[self doLogic];
	[self render];
	}

-(void)doLogic{
	grid->getInputs();	
	if(inputHandler->keyIsDown(kVK_Return))
		astarRunning = true;
	if(astarRunning)
		for(int a = 0; a < 1; a++)
			astar->nextStep();
	if(inputHandler->keyIsDown(kVK_Escape)){
		astar->reset();
		astarRunning = false;
		}

	[self updateInputs];
	}

-(void)render{
	glLoadIdentity();
	[self drawWindow];
	[self clearMainView];

	buffer->wipe();

	//Add various objects to frame buffer
	grid->draw();
	astar->draw();
	buffer->draw();
	
	//Swap frames
	[self.context flushBuffer];
	}

-(void)updateInputs{
	//This function only resets flags for "single press" events.
	//Key press events are handled asynchronously using standard
	//NSView callbacks

	//Reset input flags, get mouse location
	inputHandler->refresh();
	[self updateMouseLocation];
	}

-(void)updateMouseLocation{
	inputHandler->updateMouseLocation((location){(int)[window mouseLocationOutsideOfEventStream].x, (int)[window mouseLocationOutsideOfEventStream].y});
	}

-(void)clearMainView{
	glScissor(0, 0, screenWidth, screenHeight);
	glClearColor(.7, .7, .7, 1);
	glClear(GL_COLOR_BUFFER_BIT);
	}

-(void)drawWindow{
	[self clearWindow];
	
	//Draw all text on screen
	outputter->drawText();
	}

-(void)clearWindow{
	glScissor(0, 0, windowWidth, windowHeight);
	glClearColor(.7, .7, .7, 1);
	glClear(GL_COLOR_BUFFER_BIT);
	}

-(void)sampleFPS{
	//Frame-rate estimation; debugging purposes only
/*	static timeval t;

	timeval temp;
	gettimeofday(&temp, NULL);
	unsigned long long millisec = (temp.tv_sec - t.tv_sec) * 1000;
	millisec += (temp.tv_usec - t.tv_usec) / 1000.0f;

//	loopTimer->readyToFire();
*/	

	printf("%i\n", loopTimer->lastLap());

//	t = temp;
	//last = millisec;
	}

//Mouse events called by NewView class
-(void)leftMouseDown{
	inputHandler->leftMouseDown();
	}

-(void)leftMouseUp{
	inputHandler->leftMouseUp();
	}

-(void)rightMouseDown{
	inputHandler->rightMouseDown();
	}

-(void)rightMouseUp{
	inputHandler->rightMouseUp();
	}

-(void)keyDown: (unsigned short)code{
	inputHandler->keyDown(code);
	}

-(void)keyUp: (unsigned short)code{
	inputHandler->keyUp(code);
	}

@end

const char *absolutePath(const char *localPath){
	//Returns the absolute path to the Resources folder
	return [[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: @"Contents/Resources"] stringByAppendingPathComponent: [NSString stringWithUTF8String: localPath]] UTF8String];

	//Dead code

	//const char *path = [[[NSBundle mainBundle] pathForResource: [NSString stringWithUTF8String: localPath] ofType: nil] UTF8String];
	//if(path)
	//	return path;
	//else
		//return [[[NSString stringWithUTF8String: localPath] stringByAppendingPathComponent: [[[NSBundle mainBundle] bundlePath] stringByAppendingString: @"Contents/Resources"]] UTF8String];

	}
