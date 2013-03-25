#import "Creep.h"

Creep::Creep(BufferObject *buffer, Grid *gridd){
	grid = gridd;
	bufferObject = buffer;
	loc.x = 20;
	loc.y = 20;
	}

Creep::~Creep(){
	}

void Creep::init(location lo){
	loc = lo;
	}

void Creep::initRandom(){
	do{
		loc.x = rand()%gridWidth;
		loc.y = rand()%gridHeight;
		}while(collision(loc.x, loc.y));
	}

void Creep::draw(){
	bufferObject->addRect((rectangle){loc.x * tileSize, loc.y * tileSize, tileSize, tileSize}, (Color4f){0, 0, 1, 1});
	}

void Creep::moveLeft(){
	if(!collision(loc.x - 1, loc.y))
		loc.x--;
	}

void Creep::moveRight(){
	if(!collision(loc.x + 1, loc.y))
		loc.x++;
	}

void Creep::moveUp(){
	if(!collision(loc.x, loc.y + 1))
		loc.y++;
	}

void Creep::moveDown(){
	if(!collision(loc.x, loc.y - 1))
		loc.y--;
	}

void Creep::moveRandomly(){
	int temp = rand()%8;
	switch(temp){
		case 0:
			moveLeft();
			break;
		case 1:
			moveUp();
			break;
		case 2:
			moveRight();
			break;
		case 3:
			moveDown();
			break;
		default:
			break;
		}
	}

bool Creep::collision(int x, int y){
	if(x < 0 || x >= gridWidth || y < 0 || y >= gridHeight)
		return true;
	else if(grid->collision(x, y))
		return true;
	else
		return false;
	}
