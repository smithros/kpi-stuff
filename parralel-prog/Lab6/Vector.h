#pragma once
#include <random>
#include <ctime>
#include <string>
using namespace std;

class Vector {
private:
	long* grid;
	int N;
public:
	Vector();
	Vector(int N);
	Vector(long* grid, int N);
	~Vector();
	int getSize();
	long get(int i);
	Vector* sum(Vector* v);
	Vector* sub(Vector* v);
	Vector* multiply(long* a);
	Vector* multiply(Vector* v);
	Vector* sort();
	string toString();
};