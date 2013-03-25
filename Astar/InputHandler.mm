#import "InputHandler.h"

InputHandler::InputHandler(){
	leftMouseButton = false;
	_singleLeftClick = false;
	_singleRightClick = false;
	for(int a = 0; a < 126; a++){
		_keyIsDown[a] = false;
		_keySinglePress[a] = false;
		}
	}

void InputHandler::updateMouseLocation(location loc){
	_mouseLocation = loc;
	}

void InputHandler::leftMouseDown(){
	leftMouseButton = true;
	_singleLeftClick = true;
	}

void InputHandler::leftMouseUp(){
	leftMouseButton = false;
	}

void InputHandler::rightMouseDown(){
	rightMouseButton = true;
	_singleRightClick = true;
	}

void InputHandler::rightMouseUp(){
	rightMouseButton = false;
	}

void InputHandler::keyDown(unsigned short code){
	_keyIsDown[code] = true;
	_keySinglePress[code] = true;
	}

void InputHandler::keyUp(unsigned short code){
	_keyIsDown[code] = false;
	}

bool InputHandler::keyClick(unsigned short k){
	return _keyIsDown[k] && leftMouseButton;
	}

bool InputHandler::mouseInsideWindow(){
	return _mouseLocation.x >= 0 && _mouseLocation.x < screenWidth && _mouseLocation.y >= 0 && _mouseLocation.y < screenHeight;
	}

void InputHandler::refresh(){
	_singleLeftClick = false;
	_singleRightClick = false;
	for(int a = 0; a < 100; a++)
		_keySinglePress[a] = false;
	}
