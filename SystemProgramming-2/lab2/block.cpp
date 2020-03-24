#include "block.h"

Block::Block()
{   }

void Block::init(int size)
{
    this->is_free = 1;
    this->size = size;
}

int Block::free_size()
{
    return size - sizeof(Block);
}

int Block::size_ommit_header(int size)
{
    return size - sizeof(Block);
}

void *Block::get_data_ptr()
{
    return (void *)((unsigned char *)this + sizeof(Block));
}

Block *Block::data_ptr_to_block_ptr(void *data)
{
    return (Block *)((unsigned char *)data - sizeof(Block));
}