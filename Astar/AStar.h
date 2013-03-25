#import "Grid.h"
#import "Structs.h"

class Astar;

class Anode{
	private:
		Astar *astar;
		location _loc;
		Anode *parent;
		int _gCost, hCost;
		bool _isClosed;
	public:
		Anode *lNext, *lPrev;
		
		Anode();
		void init(Astar *a, location l, Anode *p);
		void calculateH();
		void calculateG();
		
		int gCost(){return _gCost;}
		int fCost();

		location loc(){return _loc;}
		void setParent(Anode *p){parent = p;}
		Anode *prnt(){return parent;}
		bool isClosed(){return _isClosed;}
		void close(){_isClosed = true;}
	};

class Astar{
	private:
		Grid *grid;
		BufferObject *bufferObject;
		Anode *current, *open, *oTail, *closed, *cTail, ***nodeGrid;

		bool done, failed;

		location _start, _destination;
	public:
		Astar(Grid *g, BufferObject *b);
		~Astar();

		void reset();

		void nextStep();

		void draw();
		void drawDependency(Anode *node);
		void drawAll();
		void highlightPath();

		Anode *smallestF();
		void tryToOpen(location loc, Anode *parent);

		void addToOpen(Anode *node);
		void removeFromOpen(Anode *node);
		void addToClosed(Anode *node);
		void removeFromClosed(Anode *node);

		void setDestination(location d){_destination = d;}
		location destination(){return _destination;}

		void setStart(location s);
		location start(){return _start;}

		bool validLocation(location l);
	};
