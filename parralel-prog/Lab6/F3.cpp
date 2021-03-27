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
// 2.25 S = (O + P + T)*(MR * MS)
DWORD F3::run() {
	cout << "Task 3 start\n";
	Vector *O = new Vector(N);
	Vector *P = new Vector(N);
	Vector *T = new Vector(N);
	Matrix *MP = new Matrix(N);
	Matrix *MR = new Matrix(N);
	Matrix *MS = new Matrix(N);
	result = (MR->multiply(MS))->multiply(O->sum(P->sum(T)));
	std::cout << result->toString() << std::endl;
	cout << "Task 3 end\n";
	delete MP;
	delete MR;
	delete MS;
	return 0;
}