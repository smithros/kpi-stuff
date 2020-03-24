#include <iostream>
#include <ctime>


#include "allocator.h"

using namespace std;


int main(int argc, char const *argv[])
{
    Allocator alloc;

    cout << alloc.dump() << endl;

    cout << "Allocating memory for x variable..." << endl;
    int *x = (int *) alloc.alloc(4);
    cout << alloc.dump() << endl;
    
    cout << "Assign x to 5..." << endl;
    *x = 5;
    cout << "X variable consist " << *x << endl;
    
    cout << "Free memory that was allocated for x..." << endl;
    alloc.free(x);
    
    cout << alloc.dump() << endl;
    return 0;
}