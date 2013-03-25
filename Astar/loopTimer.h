#ifndef _LOOPTIMER_
#define _LOOPTIMER_

#include <sys/time.h>

class LoopTimer{
	private:
		timeval t;
		int interval, lastTime;
	public:
		LoopTimer(unsigned int inter);
		~LoopTimer();
		
		bool readyToFire();
		int lastLap(){return lastTime;}
	};

#endif
