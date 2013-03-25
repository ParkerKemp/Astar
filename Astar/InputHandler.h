#ifndef _INPUTHANDLER_
#define _INPUTHANDLER_

#import <Carbon/Carbon.h>
#import "structs.h"

class InputHandler{
	private:
		bool leftMouseButton, rightMouseButton, _singleLeftClick, _singleRightClick;
		location _mouseLocation;
		bool _keyIsDown[126];
		bool _keySinglePress[126];
	
	public:
		InputHandler();
		void updateMouseLocation(location loc);
		void leftMouseDown();
		void leftMouseUp();
		void rightMouseDown();
		void rightMouseUp();
		void keyDown(unsigned short code);
		void keyUp(unsigned short code);

		bool leftMouseIsDown(){return leftMouseButton;}
		bool rightMouseIsDown(){return rightMouseButton;}
		bool keyIsDown(unsigned short k){return _keyIsDown[k];}
		location mouseLocation(){return _mouseLocation;}
		bool mouseInsideWindow();
		void refresh();

		bool singleLeftClick(){return _singleLeftClick;}
		bool singleRightClick(){return _singleRightClick;}
		bool keySinglePress(unsigned short k){return _keySinglePress[k];}
		bool keyClick(unsigned short k);
	};

#endif
