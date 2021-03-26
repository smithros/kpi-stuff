#pragma once
#include <iostream>
#include <Windows.h>
#include "Matrix.h"

class F2 {
private:
	Matrix* result;
	int N;
public:
	F2(int N);
	Matrix* getResult();
	static DWORD WINAPI startThread(void* param);
	DWORD run();
};
