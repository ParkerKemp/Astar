#import "AStar.h"

//Anode implementation----------------------------------------

Anode::Anode(){
	}

void Anode::init(Astar *a, location l, Anode *p){
	astar = a;
	_loc = l;
	parent = p;
	_isClosed = false;
	calculateH();
	calculateG();
	}

void Anode::calculateH(){
	location d = astar->destination();
	hCost = abs(d.x - _loc.x) + abs(d.y - _loc.y);
	}

void Anode::calculateG(){
	if(parent)
		_gCost = parent->gCost() + 1;
	else
		_gCost = 0;
	}

int Anode::fCost(){
	return hCost + _gCost;
	}

//Astar implementation----------------------------------------

Astar::Astar(Grid *g, BufferObject *b){
	grid = g;
	bufferObject = b;
	nodeGrid = new Anode**[grid->w()];
	for(int a = 0; a < grid->w(); a++){
		nodeGrid[a] = new Anode*[grid->h()];
		for(int b = 0; b < grid->h(); b++)
			nodeGrid[a][b] = 0;
		}
	open = 0;
	closed = 0;
	current = 0;
	done = false;
	failed = false;
	}

Astar::~Astar(){
//	delete[] open;
//	delete[] closed;
	}

void Astar::reset(){
	Anode *temp;
	for(int a = 0; a < grid->w(); a++)
		for(int b = 0; b < grid->h(); b++)
			if(nodeGrid[a][b]){
				delete nodeGrid[a][b];
				nodeGrid[a][b] = 0;
				}
	open = 0;
	closed = 0;
	current = 0;
	setStart(_start);
	done = false;
	failed = false;
	}

void Astar::nextStep(){
	if(done)
		return;
	Anode *temp = smallestF();
	if(temp)
		current = temp;
	else{
		failed = true;
		return;
		}
	location loc = current->loc();
	tryToOpen((location){loc.x - 1, loc.y}, current);
	tryToOpen((location){loc.x, loc.y - 1}, current);
	tryToOpen((location){loc.x + 1, loc.y}, current);
	tryToOpen((location){loc.x, loc.y + 1}, current);
	removeFromOpen(current);
	addToClosed(current);
	current->close();
	}

void Astar::draw(){
	if(!done){
		drawAll();
		highlightPath();
		}
	else
		highlightPath();
	bufferObject->addRect((rectangle){_start.x * tileSize, _start.y * tileSize, tileSize, tileSize}, (Color4f){0, 0, 1, 1});
	bufferObject->addRect((rectangle){_destination.x * tileSize, _destination.y * tileSize, tileSize, tileSize}, (Color4f){1, 0, 0, 1});
	}

void Astar::drawAll(){
	for(Anode *a = open; a != 0; a = a->lNext)
		bufferObject->addRect((rectangle){a->loc().x * tileSize, a->loc().y * tileSize, tileSize, tileSize}, (Color4f){.5, 1, 1, 1});
	Color4f closedColor;
	if(!failed)
		closedColor = (Color4f){0, .5, 1, 1};
	else
		closedColor = (Color4f){1, .75, 0, 1};
	for(Anode *a = closed; a != 0; a = a->lNext)
		bufferObject->addRect((rectangle){a->loc().x * tileSize, a->loc().y * tileSize, tileSize, tileSize}, closedColor);
	}

void Astar::highlightPath(){
	Color4f pathColor;
	if(failed)
		pathColor = (Color4f){1, 0, 0, 1};
	else if(!done)
		pathColor = (Color4f){1, 1, 0, 1};
	else
		pathColor = (Color4f){0, 1, 0, 1};
	for(Anode *a = current; a != 0; a = a->prnt())
		bufferObject->addRect((rectangle){a->loc().x * tileSize, a->loc().y * tileSize, tileSize, tileSize}, pathColor);
	}

void Astar::setStart(location s){
	_start = s;
	nodeGrid[s.x][s.y] = new Anode;
	nodeGrid[s.x][s.y]->init(this, s, 0);
	addToOpen(nodeGrid[s.x][s.y]);
	}

Anode *Astar::smallestF(){
	Anode *min = open;
	for(Anode *a = open; a != 0; a = a->lNext)
		if(a->fCost() < min->fCost())
			min = a;
	return min;
	}

void Astar::tryToOpen(location loc, Anode *parent){
	if(validLocation(loc))
		if(loc == _destination)
			done = true;
		else if(!grid->collision(loc.x, loc.y))
			if(!nodeGrid[loc.x][loc.y]){
				nodeGrid[loc.x][loc.y] = new Anode;
				nodeGrid[loc.x][loc.y]->init(this, loc, parent);
				addToOpen(nodeGrid[loc.x][loc.y]);
				}
			else{
				if(!nodeGrid[loc.x][loc.y]->isClosed() && parent->gCost() + 1 < nodeGrid[loc.x][loc.y]->gCost()){
					nodeGrid[loc.x][loc.y]->setParent(parent);
					nodeGrid[loc.x][loc.y]->calculateG();
					}
				}
	}

void Astar::addToOpen(Anode *node){
	if(open){
		node->lNext = open;
		node->lPrev = 0;
		open->lPrev = node;
		open = node;
		/*
		oTail->lNext = node;
		node->lPrev = oTail;
		node->lNext = 0;
		oTail = node;*/
		}
	else{
		open = node;
		open->lPrev = 0;
		open->lNext = 0;
		oTail = open;
		}
	}

void Astar::removeFromOpen(Anode *node){
	if(node == open)
		open = node->lNext;
	if(node->lPrev)
		node->lPrev->lNext = node->lNext;
	if(node->lNext)
		node->lNext->lPrev = node->lPrev;
	}

void Astar::removeFromClosed(Anode *node){
	if(node == closed)
		closed = node->lNext;
	if(node->lPrev)
		node->lPrev->lNext = node->lNext;
	if(node->lNext)
		node->lNext->lPrev = node->lPrev;
	}

void Astar::addToClosed(Anode *node){
	if(closed){
		cTail->lNext = node;
		node->lPrev = cTail;
		node->lNext = 0;
		cTail = node;
		}
	else{
		closed = node;
		closed->lPrev = 0;
		closed->lNext = 0;
		cTail = closed;
		}
	}

bool Astar::validLocation(location l){
	return l.x >= 0 && l.x < grid->w() && l.y >= 0 && l.y < grid->h();
	}

void Astar::drawDependency(Anode *node){
	rectangle rect;
	if(node->prnt()){
		if(node->prnt()->loc().x < node->loc().x) //x - 1
			rect = (rectangle){0, 3 * tileSize / 8.0, tileSize / 4.0, tileSize / 4.0};
		else if(node->prnt()->loc().x > node->loc().x) //x + 1
			rect = (rectangle){3 * tileSize / 4.0, 3 * tileSize / 8.0, tileSize / 4.0, tileSize / 4.0};
		else if(node->prnt()->loc().y < node->loc().y) //y - 1
			rect = (rectangle){3 * tileSize / 8.0, 0, tileSize / 4.0, tileSize / 4.0};
		else if(node->prnt()->loc().y > node->loc().y) //y + 1
			rect = (rectangle){3 * tileSize / 8.0, 3 * tileSize / 4.0, tileSize / 4.0, tileSize / 4.0};
		rect.x += node->loc().x * tileSize;
		rect.y += node->loc().y * tileSize;
		bufferObject->addRect(rect, (Color4f){1, 0, 0, 1});
		}
	}
