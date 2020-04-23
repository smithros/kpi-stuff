#include <iostream>
#include <cstdlib> // для system
using namespace std;
  int main()
    {
        const int size = 10 * 1024 * 1024; // Allocate 10M. L2 has indeed smaller size
        char* c = (char*)malloc(size);
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                c[j] = i * j;
        }
            std::cout << i << "\n";
      }
      system("pause");
      return 0;
    }
