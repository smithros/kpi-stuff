#include "Vector.h"
#include <iostream>

Vector::Vector() {}

Vector::Vector(int N) {
	this->N = N;
	srand(time(NULL));
	grid = new long[N];
	for (int i = 0; i < N; ++i)
		grid[i] = 1;//rand() % 20;
}

Vector::Vector(long* grid, int N) {
	this->N = N;
	this->grid = new long[N];
	for (int i = 0; i < N; ++i)
	{
		this->grid[i] = grid[i];
		//cout << grid[i] << endl;
	}
}

Vector::~Vector() {
	delete[] grid;
}

int Vector::getSize() {
	return N;
}

long Vector::get(int i) {
	return grid[i];
}

Vector* Vector::sum(Vector* v) {
	int N = getSize();
	long* newGrid = new long[N];
	for (int i = 0; i < N; ++i)
		newGrid[i] = grid[i] + v->get(i);
	Vector* newVector = new Vector(newGrid, N);
	delete[] newGrid;
	return newVector;
}

Vector* Vector::sub(Vector* v) {
	int N = getSize();
	long* newGrid = new long[N];
	for (int i = 0; i < N; ++i)
		newGrid[i] = grid[i] - v->get(i);
	Vector* newVector = new Vector(newGrid, N);
	delete[] newGrid;
	return newVector;
}

Vector* Vector::multiply(long* a) {
	int N = getSize();
	long* newGrid = new long[N];
	for (int i = 0; i < N; ++i) {
		newGrid[i] = *a * grid[i];
	}
	Vector* newVector = new Vector(newGrid, N);
	delete[] newGrid;
	return newVector;
}

Vector* Vector::multiply(Vector* v) {
	int N = getSize();
	long* newGrid = new long[N];
	for (int i = 0; i < N; ++i) {
		newGrid[i] = v->get(i) * grid[i];
	}
	Vector* newVector = new Vector(newGrid, N);
	delete[] newGrid;
	return newVector;
}


Vector* Vector::sort() {
	int N = getSize();
	long* newGrid = new long[N];
	for (int i = 0; i < N; ++i)
		newGrid[i] = grid[i];
	for (int i = 0; i < N; ++i) {
		for (int k = 0; k < N - i - 1; ++k) {
			if (newGrid[k] > newGrid[k + 1]) {
				long t = newGrid[k];
				newGrid[k] = newGrid[k + 1];
				newGrid[k + 1] = t;
			}
		}
	}
	Vector* newVector = new Vector(newGrid, N);
	delete[] newGrid;
	return newVector;
}

string Vector::toString() {
	string res = "";
	int N = getSize();
	for (int i = 0; i < N; ++i)
		res += std::to_string(grid[i]) + " ";
	return res;
}
