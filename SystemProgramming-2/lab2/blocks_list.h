#ifndef BLOCKS_LIST_H
#define BLOCKS_LIST_H

#include <iostream>
#include "block.h"

class BlocksListNode
{
public:
    Block *data;
    BlocksListNode *next;

    BlocksListNode();
    BlocksListNode(Block *block);
};


class BlocksList
{
private:
    BlocksListNode *head;
    BlocksListNode *tail;

public:
    BlocksList();
    ~BlocksList();

    void push(Block *elem);
    Block *pop();
    void del(Block *elem);

    bool is_empty();
    int len();
    // void dump()
    // {
    //     BlocksListNode *node = this->head;
    //     int i = 0;
    //     while (node != nullptr) {
    //         std::cout << i << " > " << (int*)(node->data) << std::endl;
    //         i++;
    //         node = node->next;
    //     }
    // }
};


#endif