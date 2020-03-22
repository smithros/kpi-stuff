typedef int* vector;
typedef int** matrix;

extern int N;

vector inputVector(int);
matrix inputMatrix(int);
void output(vector);

void sort(int, int);
void merge(int, int, int, int, vector);
vector copyVector(vector);
matrix copyMatrix(matrix);
matrix initMatrix();
