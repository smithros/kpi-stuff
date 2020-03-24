#include <Windows.h>
#include <iostream>
#include "MemoryAllocator.h"

using namespace std;

MemoryAllocator::MemoryAllocator(const int n) {
	int* mas = new int[n + 1];
	N = n;
	bSize = sizeof(BlockHeader) / sizeof(int);
	begin = (BlockHeader*)(&mas[0]);

	begin->prevsize = NULL;
	begin->size = &mas[n] - &mas[0] - bSize;
	begin->state = false;

	endOfMemory = &mas[n];
}

void* MemoryAllocator::mem_alloc(size_t size) {
	BlockHeader* current = begin;
	while (current->size < size || current->state) {
		if (isLast(current))
			return NULL;
		current = nextBlockHeader(current);
	}
	if ((current->size == size) || ((current->size - size) < bSize)) {
		current->state = 1;
		return getBlock(current);
	}
	else {
		return separateOnUseAndFree(current, size);
	}
}

void* MemoryAllocator::mem_realloc(void* addr, size_t size) {
	if (addr == NULL) {
		return mem_alloc(size);
	}

	BlockHeader* current = (BlockHeader*)addr - 1;
	size_t deltaSize = current->size - size; // size_t - unsigned int!!! fix it!

	if (deltaSize == 0)
		return addr;

	BlockHeader* previous = previousBlockHeader(current);
	BlockHeader* next = nextBlockHeader(current);

	if (previous == NULL)
		if (next == NULL) {
			//prev=NULL, next=NULL
			return searchNewBlock(addr, size);
		}
		else
			if (next->state)
				//prev=NULL, next=1
				return searchNewBlock(addr, size);
			else
				//prev=NULL, next=0
				return expandRight(addr, size); //check later - fixed
	else
		if (previous->state)
			if (next == NULL)
				//prev=1, next=NULL
				return searchNewBlock(addr, size);
			else
				if (next->state)
					//prev=1, next=1
					return searchNewBlock(addr, size);
				else
					//prev=1, next=0
					return expandRight(addr, size);
		else
			if (next == NULL)
				//prev=0, next=NULL
				return expandLeft(addr, size);
			else
				if (next->state)
					//prev=0, next=1
					return expandLeft(addr, size);
				else
					//prev=0, next=0
					return expandBoth(addr, size);

	return NULL;
}

void MemoryAllocator::mem_free(void* addr) {
	BlockHeader* current = (BlockHeader*)addr - 1;
	BlockHeader* next = nextBlockHeader(current);
	BlockHeader* previous = previousBlockHeader(current);


	if (previous == NULL)
		if (next == NULL)
			//prev=NULL, next=NULL
			current->state = false;
		else
			if (next->state)
				//prev=NULL, next=1
				current->state = false;
			else
				//prev=NULL, next=0
				mergeWithNext(current, next);
	else
		if (previous->state)
			if (next == NULL)
				//prev=1, next=NULL
				current->state = false;
			else
				if (next->state)
					//prev=1, next=1
					current->state = false;
				else
					//prev=1, next=0
					mergeWithNext(current, next);
		else
			if (next == NULL)
				//prev=0, next=NULL
				mergeWithPrevious(previous, current);
			else
				if (next->state)
					//prev=0, next=1
					mergeWithPrevious(previous, current, next);
				else
					//prev=0, next=0
					mergeBoth(previous, current, next);
}

void MemoryAllocator::mem_dump() {
	BlockHeader* current = begin;
	int i = 0;
	cout << "-------------All Blocks-----------" << endl;
	while (current != NULL) {
		cout << i << ". " << current << "   " << current->state << "   " << current->size << "   " << current->prevsize << endl;
		i++;
		current = nextBlockHeader(current);
	}
	cout << "----------------------------------" << endl;
}

BlockHeader* MemoryAllocator::nextBlockHeader(BlockHeader* current) {
	if (isLast(current))
		return NULL;

	return (BlockHeader*)((int*)((char*)current + sizeof(BlockHeader)) + current->size);
}

BlockHeader* MemoryAllocator::previousBlockHeader(BlockHeader* current) {
	if (current->prevsize == NULL)
		return NULL;
	return (BlockHeader*)((int*)((char*)current - sizeof(BlockHeader)) - current->prevsize);
}

bool MemoryAllocator::isLast(BlockHeader* h) {
	if (((int*)((char*)h + sizeof(BlockHeader)) + h->size) == endOfMemory)
		return true;
	else
		return false;
}


void MemoryAllocator::initBlockHeader(BlockHeader* bh, bool state, size_t previous, size_t size, int mask) {
	if (bh == NULL)
		return;
	if (mask & 4) {
		bh->state = state;
	}
	if (mask & 2) {
		bh->prevsize = previous;
	}
	if (mask & 1)
		bh->size = size;
}

void* MemoryAllocator::separateOnUseAndFree(BlockHeader* current, size_t size) {
	size_t curSize = current->size;
	BlockHeader* next = nextBlockHeader(current);
	if (next == NULL) {
		initBlockHeader(current, true, NULL, size, 5);
		BlockHeader* next1 = nextBlockHeader(current);
		initBlockHeader(next1, false, size, (curSize - size - bSize), 7);
		return getBlock(current);
	}
	else {
		initBlockHeader(current, true, NULL, size, 5);
		BlockHeader* next1 = nextBlockHeader(current);
		initBlockHeader(next1, false, size, (curSize - size - bSize), 7);
		next->prevsize = next1->size;
		return getBlock(current);
	}
}

void* MemoryAllocator::getBlock(BlockHeader* h) {
	return (void*)(h + 1);
}

void MemoryAllocator::copyData(void* from, void* to, size_t quantity) {
	int* f = (int*)from;
	int* t = (int*)to;
	for (unsigned int i = 0; i < quantity; i++)
		t[i] = f[i];
}

void* MemoryAllocator::searchNewBlock(void* addr, size_t size) {

	BlockHeader* current = (BlockHeader*)addr - 1;
	size_t deltaSize = current->size - size;

	if ((deltaSize > 0) && (deltaSize < 3)) {
		return addr;
	}

	if (deltaSize > 0) {
		return separateOnUseAndFree((BlockHeader*)addr - 1, size);
	}
	else {
		void* nBlock = mem_alloc(size);
		if (nBlock != NULL) {
			copyData(addr, nBlock, current->size);
			mem_free(addr);
			return nBlock;
		}
		return NULL;
	}
}

void MemoryAllocator::mergeWithNext(BlockHeader* current, BlockHeader* next) {
	current->size += next->size + sizeof(BlockHeader) / sizeof(int);
	current->state = false;
	BlockHeader* next2 = nextBlockHeader(next);
	if (next2 != NULL)
		next2->prevsize = current->size;
}

void MemoryAllocator::mergeWithPrevious(BlockHeader* previous, BlockHeader* current) {
	previous->size += current->size + sizeof(BlockHeader) / sizeof(int);
}

void MemoryAllocator::mergeWithPrevious(BlockHeader* previous, BlockHeader* current, BlockHeader* next) {
	previous->size += current->size + sizeof(BlockHeader) / sizeof(int);
	next->prevsize = previous->size;
}

void MemoryAllocator::mergeBoth(BlockHeader* previous, BlockHeader* current, BlockHeader* next) {
	previous->size += current->size + next->size + 2 * sizeof(BlockHeader) / sizeof(int);
	BlockHeader* next2 = nextBlockHeader(next);
	if (next2 != NULL)
		next2->prevsize = previous->size;
}

void* MemoryAllocator::expandLeft(void* addr, size_t size) {

	BlockHeader* current = (BlockHeader*)addr - 1;
	BlockHeader* previous = previousBlockHeader(current);
	size_t area = current->size + current->prevsize + sizeof(BlockHeader) / sizeof(int);
	size_t deltaSize = current->size - size;

	if (deltaSize > 0) { //minimize
		//copy
		int* first = (int*)addr;
		for (int i = size - 1; i >= 0; i--) {
			first[i + deltaSize] = first[i];
		}
		//set BlockHeaders
		previous->size += deltaSize;

		current = nextBlockHeader(previous);
		initBlockHeader(current, true, previous->size, size, 7);

		BlockHeader* next = nextBlockHeader(current);
		if (next != NULL)
			next->prevsize = current->size;

		return getBlock(current);
	}
	else { //maximize
		if (area >= size)
			if ((area == size) || ((area - size) < 3)) {
				//set BH
				previous->size = area;
				BlockHeader* next = nextBlockHeader(current);
				if (next != NULL)
					next->prevsize = previous->size;
				previous->state = true;
				//copy
				copyData(addr, getBlock(previous), current->size);
				return getBlock(previous);
			}
			else {
				previous->size = size;
				previous->state = true;
				copyData(addr, getBlock(previous), current->size);

				current = nextBlockHeader(previous);
				current->size = area - size - sizeof(BlockHeader) / sizeof(int);
				current->state = false;
				current->prevsize = previous->size;
				BlockHeader* next = nextBlockHeader(current);
				if (next != NULL)
					next->prevsize = current->size;
				return getBlock(previous);
			}
		else {
			void* p = mem_alloc(size);
			if (p != NULL) {
				copyData(addr, p, current->size);
				BlockHeader* next = nextBlockHeader(current);
				if (next == NULL)
					mergeWithPrevious(previous, current);
				else
					mergeWithPrevious(previous, current, next);
				return p;
			}
		}
	}
	return NULL;
}
void* MemoryAllocator::expandRight(void* addr, size_t size) {
	BlockHeader* current = (BlockHeader*)addr - 1;
	BlockHeader* next = nextBlockHeader(current);
	size_t area = current->size + next->size + sizeof(BlockHeader) / sizeof(int);
	int deltaSize = (int)(current->size) - (int)(size); //TODO: fis expression to int - fixed

	if (deltaSize > 0) { //minimize		
		//set BlockHeaders
		current->size = size;
		next = nextBlockHeader(current);
		initBlockHeader(next, false, current->size, area - size - sizeof(BlockHeader) / sizeof(int), 7);
		BlockHeader* next2 = nextBlockHeader(next);
		if (next2 != NULL)
			next2->prevsize = next->size;
		return getBlock(current);
	}
	else { //maximize
		if (area >= size)
			if ((area - size) < 3) {
				//set BH
				current->size = area;
				next = nextBlockHeader(current);
				if (next != NULL)
					next->prevsize = current->size;
				return getBlock(current);
			}
			else {
				current->size = size;

				next = nextBlockHeader(current);
				next->size = area - size - sizeof(BlockHeader) / sizeof(int);
				next->prevsize = size;
				next->state = false;
				BlockHeader* next2 = nextBlockHeader(next);
				if (next2 != NULL)
					next2->prevsize = next->size;
				return getBlock(current);
			}
		else {
			void* p = mem_alloc(size);
			if (p != NULL) {
				copyData(addr, p, current->size);
				next = nextBlockHeader(current);
				mergeWithNext(current, next);
				return p;
			}
		}
	}
	return NULL;
}
void* MemoryAllocator::expandBoth(void* addr, size_t size) {

	BlockHeader* current = (BlockHeader*)addr - 1;
	BlockHeader* previous = previousBlockHeader(current);
	BlockHeader* next = nextBlockHeader(current);
	size_t area = current->size + previous->size + next->size + 2 * sizeof(BlockHeader) / sizeof(int);
	int deltaSize = (int)(current->size) - (int)(size); //fix unsigned - fixed

	if (deltaSize > 0) { //minimize
		mergeBoth(previous, current, next);
		//copy
		copyData(addr, getBlock(previous), size);
		return separateOnUseAndFree(previous, size);
	}
	else { //maximize
		if (area >= size)
			if ((area == size) || ((area - size) < 3)) {
				//set BH
				previous->size = area;
				BlockHeader* next2 = nextBlockHeader(next);
				if (next2 != NULL)
					next2->prevsize = previous->size;
				previous->state = true;
				//copy
				copyData(addr, getBlock(previous), current->size);
				return getBlock(previous);
			}
			else {
				mergeBoth(previous, current, next);
				//copy
				copyData(addr, getBlock(previous), current->size);
				return separateOnUseAndFree(previous, size);
			}
		else {
			void* p = mem_alloc(size);
			if (p != NULL) {
				copyData(addr, p, current->size);
				mergeBoth(previous, current, next);
				return p;
			}
		}
	}
	return NULL;
}

bool MemoryAllocator::checkDamage(int filler) {
	BlockHeader* current = begin;
	int count = 0;
	while (true) {
		if (isLast(current))
			break;
		void* start = getBlock(current);
		for (unsigned int i = 0; i < current->size; i++) {
			if (*((int*)start + i) != filler) {
				count++;
			}
		}
		current = nextBlockHeader(current);
	}
	if (count) {
		cout << "damaged: " << endl;
		return true;
	}
	else {
		return false;
	}
}

