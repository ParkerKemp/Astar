#ifndef _BUFFEROBJECT_
#define _BUFFEROBJECT_

#import <Cocoa/Cocoa.h>
#import "glfont.h"
#import "structs.h"

class BufferObject{
	private:
		vertex *triVerts, *lineVerts;

		//Debugging purposes
		vertex *texCoords;

		Color4f *triColors, *lineColors;
		int totalCount, triCount, lineCount;
		GLFont font;
		unsigned int fontTex;
	public:
		BufferObject(int triNum, int lineNum);
		~BufferObject();

		void loadFont(const char *filename);
		void drawString(const char *s, int x, int y, float size);

		void wipe();
		void draw();
		void addRect(rectangle rect, Color4f color);
		void addLine(line l, Color4f color);
		int numTriangles(){return triCount;}
		int totalSize(){return totalCount;}
	};

#endif
