#ifndef _CREEP_
#define _CREEP_

#import <stdlib.h>
#import "structs.h"
#import "BufferObject.h"
#import "Grid.h"

class Creep{
	private:
		location loc;
		BufferObject *bufferObject;
		Grid *grid;
	public:
		Creep(BufferObject *buffer, Grid *gridd);
		~Creep();
		void init(location lo);
		void initRandom();
		void draw();
		void moveLeft();
		void moveRight();
		void moveUp();
		void moveDown();
		void moveRandomly();
		bool collision(int x, int y);
	};

#endif
