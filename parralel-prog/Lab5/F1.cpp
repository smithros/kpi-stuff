#include "F1.h"

F1::F1(int N) {
	this->N = N;
}

Vector* F1::getResult() {
	return result;
}

DWORD WINAPI F1::startThread(void* param) {
	F1* This = (F1*)param;
	return This->run();
}

DWORD F1::run() {
	cout << "Task 1 start\n";
	Vector *B = new Vector(N);
	Matrix *MB = new Matrix(N), *MC = new Matrix(N);
	result = (MB->multiply(MC))->multiply(B->sort());
	cout << result->toString() << endl;
	cout << "Task 1 end\n";
	delete B;
	delete MB;
	delete MC;
	return 0;
}