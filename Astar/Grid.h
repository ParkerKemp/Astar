#ifndef _GRID_
#define _GRID_

#import <stdio.h>
#import "BufferObject.h"
#import "InputHandler.h"

class Grid{
	private:
		int _w, _h, **tiles;
		BufferObject *bufferObject;
		InputHandler *inputHandler;
	public:
		Grid(int width, int height, BufferObject *buffer, InputHandler *input);
		~Grid();

		void clear();
		bool collision(int x, int y);
		bool readTerrainFile(const char *filename);
		bool writeTerrainFile(const char *filename);
		void draw();
		void getInputs();
		location tileFromCoords(int x, int y);
		int w(){return _w;}
		int h(){return _h;}
	};

#endif
