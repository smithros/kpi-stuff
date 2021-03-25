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
	long e = N;
	Vector *A = new Vector(N), *B = new Vector(N);
	Matrix *MA = new Matrix(N), *MC = new Matrix(N);
	result = A->sub((MA->multiply(MC))->multiply(B)->multiply(&e));
	cout << "Task 1 end\n";
	delete A;
	delete B;
	delete MA;
	delete MC;
	return 0;
}