#pragma once
#include <iostream>
#include <Windows.h>
#include "Matrix.h"

class F1 {
private:
	Vector* result;
	int N;
public:
	F1(int N);
	Vector* getResult();
	static DWORD WINAPI startThread(void* param);
	DWORD run();
};
