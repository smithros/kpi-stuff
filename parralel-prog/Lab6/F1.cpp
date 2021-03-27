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
//1.12  A = B + C + D*(MD*ME) 
DWORD F1::run() {
	cout << "Task 1 start\n";
	Vector *D = new Vector(N);
	Vector *B = new Vector(N);
	Vector *C = new Vector(N);
	Matrix *MD = new Matrix(N);
	Matrix *ME = new Matrix(N);
	result = ((MD->multiply(ME))->multiply(D)->sum(B))->sum(C);
	cout << result->toString() << endl;
	cout << "Task 1 end\n";
	delete D;
	delete B;
	delete C;
	delete MD;
	delete ME;
	return 0;
}