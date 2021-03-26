#include <omp.h>
#include <iostream>
#include <string>
#include "F1.h"
#include "F2.h"
#include "F3.h"

//  Task:
//  F1: 1.1. A = SORT(B) (MB*MC) 
//	F2 : 2.20  MK = ML + MH *MG 
//	F3 3.1   O = MP*MR + MS

using namespace std;
const int N = 10;

int main() {
	cout << "Lab 5 start" << endl << endl;
	F1 f1 = F1(N);
	F2 f2 = F2(N);
	F3 f3 = F3(N);
	int tid;

#pragma omp parallel num_threads(3)
	{
		tid = omp_get_thread_num();
		switch (tid) {
		case 0:
			f1.run();
		case 1:
			f2.run();
		case 2:
			f3.run();
		}
	}

	cout << endl << "Lab 5 end" << endl << endl;
	cout << "Press Enter...";
	string t;
	getline(cin, t);
}
