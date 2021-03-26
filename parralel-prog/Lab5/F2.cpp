#include "F2.h"

F2::F2(int N) {
	this->N = N;
}

Matrix* F2::getResult() {
	return result;
}

DWORD WINAPI F2::startThread(void* param) {
	F2* This = (F2*)param;
	return This->run();
}

DWORD F2::run() {
	cout << "Task 2 start\n";
	Matrix *ML = new Matrix(N);
	Matrix *MH = new Matrix(N);
	Matrix *MG = new Matrix(N);
	result = ML->sum(MH->multiply(MG));
	std::cout << result->toString() << std::endl;
	cout << "Task 2 end\n";
	delete ML;
	delete MG;
	delete MH;
	return 0;
}