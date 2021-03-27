#include <mpi.h>
#include <iostream>
#include <string>
#include "F1.h"
#include "F2.h"
#include "F3.h"

using namespace std;

const int N = 3;

//  Task:
//  F1  1.12  A = B + C + D*(MD*ME) 
//	F2  2.21  MF = MG + (MH*MK) + ML 
//	F3  2.25 S = (O + P + T)*(MR * MS)

int main(int argc, char* argv[]) {
	MPI_Init(&argc, &argv);
	int id;
	MPI_Comm_rank(MPI_COMM_WORLD, &id);
	F1 f1 = F1(N);
	F2 f2 = F2(N);
	F3 f3 = F3(N);
	switch (id) {
	case 0:
		f1.run();
	case 1:
		f2.run();
	case 2:
		f3.run();
	}
	cout << "Press Enter...";
	string t;
	getline(cin, t);
	MPI_Finalize();
}
