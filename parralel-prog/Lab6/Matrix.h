#pragma once
#include <random>
#include <ctime>
#include "Vector.h"


class Matrix {
private:
	long** grid;
	int N;
public:
	Matrix(int N);
	Matrix(long** grid, int N);
	~Matrix();
	long get(int i, int k);
	int getSize();
	Matrix* multiply(Matrix* m);
	Vector* multiply(Vector* v);
	Matrix* multiply(long* a);
	Matrix* sum(Matrix* m);
	long get_min();
	long get_max();
	string toString();
};