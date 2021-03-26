#include "Matrix.h"
#include <iostream>

Matrix::Matrix(int N) {
	this->N = N;
	srand(time(NULL));
	grid = new long*[N];
	for (int i = 0; i < N; ++i)
		grid[i] = new long[N];
	for (int i = 0; i < N; ++i)
		for (int k = 0; k < N; ++k)
			grid[i][k] = 1;//rand() % 20;
}

Matrix::Matrix(long** grid, int N) {
	this->N = N;
	this->grid = new long*[N];
	for (int i = 0; i < N; ++i) {
		this->grid[i] = new long[N];
		for (int k = 0; k < N; ++k)
			this->grid[i][k] = grid[i][k];
	}
}

Matrix::~Matrix() {
	int N = getSize();
	for (int i = 0; i < N; ++i)
		delete[] grid[i];
	delete[] grid;
}

long Matrix::get(int i, int k) {
	return grid[i][k];
}

int Matrix::getSize() {
	return N;
}

Matrix* Matrix::multiply(Matrix* m) {
	int N = getSize();
	long** newGrid = new long*[N];
	for (int i = 0; i < N; ++i)
		newGrid[i] = new long[N];
	for (int i = 0; i < N; ++i) {
		for (int k = 0; k < N; ++k) {
			newGrid[i][k] = 0;
			for (int j = 0; j < N; ++j) {
				newGrid[i][k] += grid[i][j] * m->get(j, k);
			}
		}
	}
	Matrix* newMatrix = new Matrix(newGrid, N);
	for (int i = 0; i < N; ++i)
		delete[] newGrid[i];
	delete[] newGrid;
	return newMatrix;
}

Vector* Matrix::multiply(Vector* v) {
	int N = getSize();
	long* newGrid = new long[N];
	for (int i = 0; i < N; ++i) {
		newGrid[i] = 0;
		for (int k = 0; k < N; ++k) {
			newGrid[i] += v->get(k) * grid[i][k];
		}
	}
	Vector* newVector = new Vector(newGrid, N);
	delete[] newGrid;
	return newVector;
}

Matrix* Matrix::multiply(long *a) {
	int N = getSize();
	long** newGrid = new long*[N];
	for (int i = 0; i < N; ++i)
		newGrid[i] = new long[N];
	for (int i = 0; i < N; ++i) {
		for (int k = 0; k < N; ++k) {
			newGrid[i][k] = grid[i][k] * *a;
		}
	}
	Matrix* newMatrix = new Matrix(newGrid, N);
	for (int i = 0; i < N; ++i)
		delete[] newGrid[i];
	delete[] newGrid;
	return newMatrix;
}

Matrix* Matrix::sum(Matrix* m) {
	int N = getSize();
	long** newGrid = new long*[N];
	for (int i = 0; i < N; ++i)
		newGrid[i] = new long[N];
	for (int i = 0; i < N; ++i) {
		for (int k = 0; k < N; ++k) {
			newGrid[i][k] = grid[i][k] + m->get(i, k);
		}
	}
	Matrix* newMatrix = new Matrix(newGrid, N);
	for (int i = 0; i < N; ++i)
		delete[] newGrid[i];
	delete[] newGrid;
	return newMatrix;
}

long Matrix::get_min() {
	long res = grid[0][0];
	int N = getSize();
	for (int i = 0; i < N; ++i) {
		for (int k = 0; k < N; ++k) {
			if (res < grid[i][k])
				res = grid[i][k];
		}
	}
	return res;
}

long Matrix::get_max() {
	long res = grid[0][0];
	int N = getSize();
	for (int i = 0; i < N; ++i) {
		for (int k = 0; k < N; ++k) {
			if (res > grid[i][k])
				res = grid[i][k];
		}
	}
	return res;
}

string Matrix::toString() {
	string res = "";
	int N = getSize();
	for (int i = 0; i < N; ++i) {
		for (int k = 0; k < N; ++k) {
			res += std::to_string(grid[i][k]) + "\t";
		}
		res += "\n";
	}
	return res;
}