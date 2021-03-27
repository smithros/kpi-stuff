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
// 2.21  MF = MG + (MH*MK) + ML 
DWORD F2::run() {
	cout << "Task 2 start\n";
	Matrix *MG = new Matrix(N);
	Matrix *MH = new Matrix(N);
	Matrix *MK = new Matrix(N);
	Matrix *ML = new Matrix(N);
	result = (MG->sum(MH->multiply(MK)))->sum(ML);
	std::cout << result->toString() << std::endl;
	cout << "Task 2 end\n";
	delete MG;
	delete MH;
	delete MK;
	delete ML;
	return 0;
}