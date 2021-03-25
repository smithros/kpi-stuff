#pragma once
#include <iostream>
#include <Windows.h>
#include "Matrix.h"

class F3 {
private:
	Vector* result;
	int N;
public:
	F3(int N);
	Vector* getResult();
	static DWORD WINAPI startThread(void* param);
	DWORD run();
};
