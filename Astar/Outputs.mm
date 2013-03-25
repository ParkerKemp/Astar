#include "Outputs.h"

Outputter::Outputter(BufferObject *b){
	buffer = b;
	}

Outputter::~Outputter(){}

void Outputter::drawText(){
/*	static float f = 20;
	f += 0.05;
	if(f > 40)
		f = 20;
*/
	printf("drawing text\n");

	buffer->drawString("A* Demonstration", 20, 635, 16);
	buffer->drawString("Controls:", 20, 619, 16);
	buffer->drawString("ENTER = Begin algorithm", 20, 600, 20);
	buffer->drawString("O = Open last maze", 20, 575, 20);
	buffer->drawString("S = Save maze", 20, 550, 20);
	buffer->drawString("C = Clear screen", 20, 525, 20);
	}
