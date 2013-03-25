#import "Grid.h"

Grid::Grid(int width, int height, BufferObject *buffer, InputHandler *input){
	inputHandler = input;
	bufferObject = buffer;
	_w = width;
	_h = height;
	tiles = new int*[_w];
	for(int a = 0; a < _w; a++)
		tiles[a] = new int[_h];
	for(int a = 0; a < _w; a++)
		for(int b = 0; b < _h; b++)
			tiles[a][b] = 0;
	}

Grid::~Grid(){
	for(int a = 0; a < _w; a++)
		delete[] tiles[a];
	delete[] tiles;
	}

bool Grid::collision(int x, int y){
	if(x < 0 || x >= gridWidth || y < 0 || y > gridHeight)	
		printf("asdf\n");
	return tiles[x][y] != 0;
	}

void Grid::draw(){
	for(int a = 0; a < _w; a++)
		for(int b = 0; b < _h; b++)
			if(tiles[a][b] == 1)
				bufferObject->addRect((rectangle){a * tileSize, b * tileSize, tileSize, tileSize}, (Color4f){0, 0, 0, 1});
	for(int a = 0; a < _w + 1; a++)
		bufferObject->addLine((line){(vertex){a * tileSize, 0}, (vertex){a * tileSize, gridHeight * tileSize}}, (Color4f){0, 0, 0, 1});
	for(int a = 0; a < _h + 1; a++)
		bufferObject->addLine((line){(vertex){0, a * tileSize}, (vertex){gridWidth * tileSize, a * tileSize}}, (Color4f){0, 0, 0, 1});
	}

bool Grid::readTerrainFile(const char *filename){
	FILE *file;
	if(!(file = fopen(filename, "r")))
		return false;
	int *blocks;
	blocks = new int[_w * _h * 2];
	int temp = 0;
	while(temp < _w * _h && fscanf(file, "%i", &blocks[temp]) != EOF)
		temp++;
	clear();
	for(int a = 0; a < temp; a += 2)
		tiles[blocks[a]][blocks[a + 1]] = 1;
	fclose(file);
	delete[] blocks;
	return true;
	}

bool Grid::writeTerrainFile(const char *filename){
	FILE *file;
	if(!(file = fopen(filename, "w")))
		return false;
	for(int a = 0; a < _w; a++)
		for(int b = 0; b < _h; b++)
			if(tiles[a][b] == 1)
				fprintf(file, "%i %i\n", a, b);
	fclose(file);
	return true;
	}

void Grid::getInputs(){
	location mouseLoc = inputHandler->mouseLocation();
	location mouseTile = tileFromCoords(mouseLoc.x, mouseLoc.y);
	if(inputHandler->mouseInsideWindow()) 
		if(inputHandler->keyClick(kVK_ANSI_E))
			tiles[mouseTile.x][mouseTile.y] = 0;
		else if(inputHandler->leftMouseIsDown())
			tiles[mouseTile.x][mouseTile.y] = 1;
	if(inputHandler->keySinglePress(kVK_ANSI_S))
		if(!writeTerrainFile(absolutePath("terrain.t")))
			printf("Error: could not write terrain file!\n");
	if(inputHandler->keySinglePress(kVK_ANSI_O))
		if(!readTerrainFile(absolutePath("terrain.t")))
			printf("Error: terrain file does not exist!\n");
	if(inputHandler->keySinglePress(kVK_ANSI_C))
		clear();
	}

location Grid::tileFromCoords(int x, int y){
	location temp;
	if(x >= 0 && x < screenWidth && y >= 0 && y < screenHeight){
		temp.x = x / tileSize;
		temp.y = y / tileSize;
		}
	else
		;//printf("Warning: tried to retrieve tile outside of window!\n");
	return temp;
	}

void Grid::clear(){
	for(int a = 0; a < _w; a++)
		for(int b = 0; b < _h; b++)
			tiles[a][b] = 0;
	}
