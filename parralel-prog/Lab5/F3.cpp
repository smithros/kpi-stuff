#include "F3.h"

F3::F3(int N) {
	this->N = N;
}

Matrix* F3::getResult() {
	return result;
}

DWORD WINAPI F3::startThread(void* param) {
	F3* This = (F3*)param;
	return This->run();
}

DWORD F3::run() {
	cout << "Task 3 start\n";
	Matrix *MP = new Matrix(N);
	Matrix *MR = new Matrix(N);
	Matrix *MS = new Matrix(N);
	result = MS->sum(MP->multiply(MR));
	std::cout << result->toString() << std::endl;
	cout << "Task 3 end\n";
	delete MP;
	delete MR;
	delete MS;
	return 0;
}