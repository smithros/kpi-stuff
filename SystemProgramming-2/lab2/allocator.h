#ifndef ALLOCATOR_H
#define ALLOCATOR_H

#include <string>
#include <sstream>
#include <iomanip>

#include "blocks_list.h"

using namespace std;

class AllocHeader
{
public:
    typedef unsigned char byte;

    const static int categories_amount = 12;
    const static int block_sizes[categories_amount];

    void init(int size);

    bool is_suit_size(int size);
    Block *get_suit_block(int size);
    static bool can_make_twin(Block *block, int needed_size);
    Block *make_suit_block(int from_block_class, int size);
    void join_twins_recursive(Block *block);

    std::string dump();
    BlocksList *free_blocks[categories_amount];
private:
    AllocHeader();
    Block *merge_blocks(Block *first_block, Block *second_block);
};


class Allocator
{
private:
    AllocHeader *header;

public:
    typedef unsigned char byte;
    Allocator(int size=65536);
    ~Allocator();
    std::string dump();

    void *alloc(int size);
    void free(void *data);

    bool test();
};


#endif