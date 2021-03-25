#include "F3.h"

F3::F3(int N) {
	this->N = N;
}

Vector* F3::getResult() {
	return result;
}

DWORD WINAPI F3::startThread(void* param) {
	F3* This = (F3*)param;
	return This->run();
}

DWORD F3::run() {
	cout << "Task 3 start\n";
	Vector *P = new Vector(N);
	Matrix *MT = new Matrix(N), *MR = new Matrix(N);
	result = (MR->multiply(MT))->multiply(P->sort());
	cout << "Task 3 end\n";
	delete P;
	delete MT;
	delete MR;
	return 0;
}