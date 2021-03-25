#include "F1.h"
#include "F2.h"
#include "F3.h"

const int N = 2;

int main() {
	cout << "Lab 4 start" << endl << endl;
	DWORD tid[3];
	HANDLE threads[3];
	F1* f1 = new F1(N);
	F2* f2 = new F2(N);
	F3* f3 = new F3(N);

	threads[0] = CreateThread(NULL, 0, F1::startThread, f1, 1, &tid[0]);
	threads[1] = CreateThread(NULL, 0, F2::startThread, f2, 2, &tid[1]);
	threads[2] = CreateThread(NULL, 0, F3::startThread, f3, 3, &tid[2]);

	WaitForMultipleObjects(3, threads, true, INFINITE);

	Vector* rf1 = f1->getResult();
	cout << "Thread 1 result: " << endl << rf1->toString() << endl;
	Matrix* rf2 = f2->getResult();
	cout << "Thread 2 result: " << endl << rf2->toString() << endl;
	Vector* rf3 = f3->getResult();
	cout << "Thread 3 result: " << endl << rf3->toString() << endl;

	cout << endl << "Lab 4 end" << endl << endl << "Press Enter...";
	string t;
	getline(cin, t);
	delete f1;
	delete f2;
	delete f3;
}