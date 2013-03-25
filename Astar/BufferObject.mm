#import "BufferObject.h"

BufferObject::BufferObject(int triNum, int lineNum){
	triCount = 0;
	lineCount = 0;
	totalCount = triNum;
	triVerts = new vertex[triNum * 3];
	triColors = new Color4f[triNum * 3];

	lineVerts = new vertex[lineNum * 2];
	lineColors = new Color4f[lineNum * 2];

	//Debugging purposes
	texCoords = new vertex[triNum * 3];
	}

BufferObject::~BufferObject(){
	delete[] triVerts;
	delete[] triColors;
	delete[] lineVerts;
	delete[] lineColors;
	}

void BufferObject::loadFont(const char *filename){
	printf("loading font...\n");
	glEnable(GL_TEXTURE_2D);
//	printf("%i\n", fontTex);
	glGenTextures(1, &fontTex);
//	printf("%i\n", fontTex);
	font.Create(filename, fontTex);
	glDisable(GL_TEXTURE_2D);
	}

void BufferObject::drawString(const char *s, int x, int y, float size){
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

	glColor4f(1, .5, 0, 1);
	string str = string(s);

	//Draw the string
	font.Begin();
	font.TextOut(s, x, y, 0, size);

	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	}

void BufferObject::draw(){
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	//Flush triangle buffer
	glVertexPointer(2, GL_FLOAT, 0, triVerts);
	glColorPointer(4, GL_FLOAT, 0, triColors);
	glDrawArrays(GL_TRIANGLES, 0, triCount * 3);

	//Flush line buffer
	glVertexPointer(2, GL_FLOAT, 0, lineVerts);
	glColorPointer(4, GL_FLOAT, 0, lineColors);
	glDrawArrays(GL_LINES, 0, lineCount * 2);

	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	}

void BufferObject::wipe(){
	triCount = 0;
	lineCount = 0;
	}

void BufferObject::addRect(rectangle rect, Color4f color){
	triVerts[triCount * 3].x = rect.x;
	triVerts[triCount * 3].y = rect.y;
	triVerts[triCount * 3 + 1].x = rect.x + rect.w;
	triVerts[triCount * 3 + 1].y = rect.y;
	triVerts[triCount * 3 + 2].x = rect.x;
	triVerts[triCount * 3 + 2].y = rect.y + rect.h;
	triVerts[triCount * 3 + 3].x = rect.x + rect.w;
	triVerts[triCount * 3 + 3].y = rect.y;
	triVerts[triCount * 3 + 4].x = rect.x;
	triVerts[triCount * 3 + 4].y = rect.y + rect.h;
	triVerts[triCount * 3 + 5].x = rect.x + rect.w;
	triVerts[triCount * 3 + 5].y = rect.y + rect.h;
	for(int a = 0; a < 6; a++)
		triColors[triCount * 3 + a] = color;
	triCount += 2;
	}

void BufferObject::addLine(line l, Color4f color){
	lineVerts[lineCount * 2] = l.p1;
	lineVerts[lineCount * 2 + 1] = l.p2;
	lineColors[lineCount * 2] = color;
	lineColors[lineCount * 2 + 1] = color;
	lineCount++;
	}
