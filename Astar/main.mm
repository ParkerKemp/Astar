#import "AppDelegate.h"

int main(int argc, char **argv){
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	AppDelegate *delegate = [[[AppDelegate alloc] init] autorelease];
	[[NSApplication sharedApplication] setDelegate: delegate];
	[NSApp run];
	
	[pool drain];
	return 0;
	}
