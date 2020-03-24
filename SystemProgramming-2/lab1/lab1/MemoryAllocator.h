struct BlockHeader {
	bool state; //1 - used, 0 - unused
	size_t size;
	size_t prevsize;
};

class MemoryAllocator {

public:
	MemoryAllocator(const int n);
	//return addr on begin of allocated block or NULL
	void* mem_alloc(size_t size);
	//return addr on begin of reallocated block or NULL
	void* mem_realloc(void* addr, size_t size);
	//free block by this address
	void mem_free(void* addr);
	//out blocks characteristic in table on console
	void mem_dump();

private:
	size_t bSize; //struct BlockHeader size in int
	int N; // length all memory in int
	BlockHeader* begin; //first block
	int* endOfMemory; //last int in memory

	//all blocks must be fill the same number	
	bool checkDamage(int filler);
	//return next BH or NULL if it block is last
	BlockHeader* nextBlockHeader(BlockHeader* current);
	//return previous BH or NULL if it block is first
	BlockHeader* previousBlockHeader(BlockHeader* current);
	//check if endOfMemory belongs to this block
	bool isLast(BlockHeader* h);

	//next 4 functions merge 2 or 3 free blocks

	void mergeWithNext(BlockHeader* current, BlockHeader* next);
	void mergeWithPrevious(BlockHeader* previous, BlockHeader* current);
	void mergeWithPrevious(BlockHeader* previous, BlockHeader* current, BlockHeader* next);
	void mergeBoth(BlockHeader* previous, BlockHeader* current, BlockHeader* next);

	//copy data in new block (all  or part = length of new block)
	void copyData(void* from, void* to, size_t quantity);

	//return link on finded free block or NULL
	void* searchNewBlock(void* addr, size_t size);

	//next functions merge 2 or 3 blocks (one is use), then separate them on use and free and copy data to new use

	void* expandLeft(void* addr, size_t size);
	void* expandRight(void* addr, size_t size);
	void* expandBoth(void* addr, size_t size);

	//set fields of BH selected by mask
	void initBlockHeader(BlockHeader* bh, bool state, size_t previous, size_t size, int mask);//mask 7 (binary: 111) - all
	//size - length of new use block
	void* separateOnUseAndFree(BlockHeader* current, size_t size);
	//return begin of memory block for user (after BH)
	void* getBlock(BlockHeader* h);
};

