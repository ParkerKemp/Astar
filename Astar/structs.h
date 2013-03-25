#define windowWidth 1000
#define windowHeight 700
#define screenWidth 1000
#define screenHeight 500
#define gridWidth 50
#define gridHeight 25
#define tileSize 20.0f
#define framerate 200.0

const char *absolutePath(const char *localPath);

class location{
	public:
		int x;
		int y;

	bool operator ==(location l){
		return x == l.x && y == l.y;
		}
	};

struct vertex{
	float x;
	float y;
	};

struct line{
	vertex p1;
	vertex p2;
	};

struct rectangle{
	float x;
	float y;
	float w;
	float h;
	};

struct Color4f{
	float r;
	float g;
	float b;
	float a;
	};
