#include "loopTimer.h"

LoopTimer::LoopTimer(unsigned int inter){
	interval = inter;
	gettimeofday(&t, NULL);
	}

LoopTimer::~LoopTimer(){}

bool LoopTimer::readyToFire(){
	timeval temp;
	unsigned int elapsedTime;
	
	//Get updated time
	gettimeofday(&temp, NULL);
	
	//Find elapsed time in milliseconds from last check
	elapsedTime = (temp.tv_sec - t.tv_sec) * 1000;
	elapsedTime += (temp.tv_usec - t.tv_usec) / 1000;

	if(elapsedTime >= interval){
		t = temp;
		lastTime = elapsedTime;
		return true;
		}
	else
		return false;
	}
