#ifndef _OUTPUTS_
#define _OUTPUTS_

#include "BufferObject.h"

class Outputter{
	private:
		BufferObject *buffer;
	
	public:
		Outputter(BufferObject *b);
		~Outputter();
		void drawText();
	};

#endif
