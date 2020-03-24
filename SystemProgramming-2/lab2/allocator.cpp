#include "allocator.h"

#include <iostream>
const int AllocHeader::block_sizes[AllocHeader::categories_amount] = {
        32, 64, 128,
        256, 512, 1024,
        2048, 4096, 8192,
        16384, 32768, 65536,
};


AllocHeader::AllocHeader()
{
}


void AllocHeader::init(int size)
{
    // finding pointer on first data block
    Block *first_block = (Block *)((AllocHeader::byte *)this + sizeof(AllocHeader));

    first_block->init(size);

    // init array with empty lists
    for (int i = 0; i < AllocHeader::categories_amount; i++) {
        this->free_blocks[i] = new BlocksList();
    }

    // add first block to array of free blocks
    for (int i = AllocHeader::categories_amount - 1; i >= 0; i--) {
        if (size == AllocHeader::block_sizes[i]) {
            this->free_blocks[i]->push(first_block);
            return;
        }
    }
    throw "Invalid allocator size.";
}

Block *AllocHeader::get_suit_block(int size)
{
    for (int i = 0; i < AllocHeader::categories_amount; i++) {
        if (Block::size_ommit_header(AllocHeader::block_sizes[i]) >= size &&
            !this->free_blocks[i]->is_empty())
        {
            return this->make_suit_block(i, size);
        }
    }
}

bool AllocHeader::can_make_twin(Block *block, int needed_size)
{
    if (block->size / 2 - sizeof(Block) >= needed_size) {
        return true;
    }
    return false;
}

Block *AllocHeader::make_suit_block(int from_block_class, int size)
{
    // std::cout << this->dump() << std::endl;
    Block *block = this->free_blocks[from_block_class]->pop();

    if (from_block_class > 0 && this->can_make_twin(block, size)) {
        int twin_block_size = block->size / 2;

        Block *twin_block = (Block *)((AllocHeader::byte *)block + twin_block_size);
        twin_block->init(twin_block_size);

        block->size = twin_block_size;
        this->free_blocks[from_block_class - 1]->push(block);
        this->free_blocks[from_block_class - 1]->push(twin_block);

        return make_suit_block(from_block_class - 1, size);
    }
    block->is_free = 0;
    return block;
}

void AllocHeader::join_twins_recursive(Block *block)
{
    // exit funtion if current block is the biggest possible block
    if (block->size == AllocHeader::block_sizes[AllocHeader::categories_amount - 1]) {
        return;
    }
    // cout << "block is not biggest\n";

    // calculate offset to block from allocator start
    int offset_to_block = (AllocHeader::byte *)block - ((AllocHeader::byte *)this + sizeof(AllocHeader));

    // offset_to_block = (AllocHeader::byte *)block - 32;
    // cout << "TTT size: " << (twin_block->size << endl;



    // finding the power of two from block size
    int block_size = block->size;
    int power = -1;
    while (block_size > 0) {
        power++;
        block_size >>= 1;
    }

    // cout << "offset_to_block: " << offset_to_block << endl;
    // invert bit which located on power position
    offset_to_block ^= 1 << power;
    // cout << "offset_to_block: " << offset_to_block << endl;


    // fingind twin block position
    Block *twin_block = (Block *)((AllocHeader::byte *)this + sizeof(AllocHeader) + offset_to_block);

    // cout << "twin block size: " << twin_block->size << endl;
    if (block->size == twin_block->size &&
        twin_block->is_free)
    {
        Block *merged_block = this->merge_blocks(block, twin_block);
        if (merged_block != nullptr) {
//            this->free_blocks[power - 4]->push(merged_block);
            this->join_twins_recursive(merged_block);
        }
    }
}

Block *AllocHeader::merge_blocks(Block *first_block, Block *second_block)
{
    if (first_block > second_block) {
        return AllocHeader::merge_blocks(second_block, first_block);
    }
    int block_category = 0;
    for (int i = 0; i < AllocHeader::categories_amount; i++) {
        if (AllocHeader::block_sizes[i] == first_block->size) {
            block_category = i;
            break;
        }
    }

    this->free_blocks[block_category]->del(first_block);
    this->free_blocks[block_category]->del(second_block);

    first_block->size = first_block->size * 2;
    this->free_blocks[block_category + 1]->push(first_block);
    return first_block;
}



std::string AllocHeader::dump()
{
    std::string separator = "=========[ Memory dump ]=========";
    std::stringstream output;

    output << separator << std::endl;
    for (int i = 0; i < AllocHeader::categories_amount; i++) {
        int size = AllocHeader::block_sizes[i];
        int amount = this->free_blocks[i]->len();
        output << "Block_size: " << std::setw(6) << size << " => Amount: " << amount << std::endl;
    }
    output << "=================================" << std::endl;

    return output.str();
}



Allocator::Allocator(int size)
{
    void *mem = (void *) malloc(sizeof(AllocHeader) + size);
    this->header = (AllocHeader *) mem;
    this->header->init(size);
}

Allocator::~Allocator()
{   }

std::string Allocator::dump()
{
    return this->header->dump();
}

void *Allocator::alloc(int size)
{
    return header->get_suit_block(size)->get_data_ptr();
}

void Allocator::free(void *data)
{
    Block *block = Block::data_ptr_to_block_ptr(data);
    // std::cout << block->size << std::endl;
    block->is_free = 1;
    // std::cout << block->is_free << std::endl;
    int block_size = block->size;
    int power = -1;
    while (block_size > 0) {
        power++;
        block_size >>= 1;
    }
    this->header->free_blocks[power - 5]->push(block);
    header->join_twins_recursive(block);
}


bool Allocator::test()
{
    for (int i = 0; i < AllocHeader::categories_amount - 1; i++) {
        if (!this->header->free_blocks[i]->is_empty()) {
            return false;
        }
    }

    if (this->header->free_blocks[AllocHeader::categories_amount - 1]->is_empty()) {
        return false;
    }
    return true;
}