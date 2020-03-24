#ifndef BLOCK_H
#define BLOCK_H

class Block
{
private:
    Block();

public:
    unsigned is_free: 1;
    unsigned size: 23;


    void init(int size=0);
    int free_size();
    void *get_data_ptr();

    static int size_ommit_header(int size);
    static Block *data_ptr_to_block_ptr(void *data);
    // int get_size();

};

#endif