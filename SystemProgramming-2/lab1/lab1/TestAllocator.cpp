#include <iostream>
#include "MemoryAllocator.h"

using namespace std;

void fillBlock(void* start, int size, int filler) {
	for (int i = 0; i < size; i++) {
		*((int*)start + 1) = filler;
	}
}

void test_allocator() {
	cout << "Testing started! \n";
	const int len = 1500;
	const int amount = 10;
	const int bSize = 50;
	void* curBlock;
	void* mas[amount]; // has all user blocks
	
	MemoryAllocator alloc = MemoryAllocator(len);

	for (int i = 0; i < amount; i++) {
		curBlock = alloc.mem_alloc(bSize);
		mas[i] = curBlock;
		fillBlock(curBlock, 50, 170); //170(dec) = 1010 1010(bin)
	}

	cout << "Allocate 15 blocks (length = 50) \n";
	alloc.mem_dump();

	cout << "Realloc 3-rd el to 20\n"; 
	alloc.mem_realloc(mas[3], 20);
	alloc.mem_dump();

	cout << "Realloc 3-rd el to 30\n";
	alloc.mem_realloc(mas[3], 30);
	alloc.mem_dump();

	cout << "Realloc 3-rd el to 49\n";
	alloc.mem_realloc(mas[3], 49);
	alloc.mem_dump();

	cout << "Free 2-nd and 4-th elements \n";
	alloc.mem_free(mas[2]);
	alloc.mem_free(mas[4]);
	alloc.mem_dump();

	cout << "Alloc size=30 \n";
	alloc.mem_alloc(30);
	alloc.mem_dump();
	
	cout << "Realloc 3-rd element to 156 \n";
	alloc.mem_realloc(mas[3], 156);
	alloc.mem_dump();

	cout << "Realloc 2-nd element to 53 \n";
	alloc.mem_realloc(mas[2], 53);
	alloc.mem_dump();

	cout << "Test_allocator function finished! \n";
}

int main() {
	test_allocator();
	cout << "Type something to exit! \n";
	getchar();
	return 0;
}

