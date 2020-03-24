#include "blocks_list.h"


BlocksListNode::BlocksListNode(): data(nullptr), next(nullptr)
{   }


BlocksListNode::BlocksListNode(Block *block) : data(block), next(nullptr)
{   }




BlocksList::BlocksList()
{
    this->head = nullptr;
    this->tail = nullptr;
}


void BlocksList::push(Block *block)
{
    BlocksListNode *node = new BlocksListNode(block);
    if (this->tail == nullptr) {
        this->head = node;
        this->tail = node;
    }
    else {
        this->tail->next = node;
        this->tail = node;
    }
}


Block *BlocksList::pop()
{
    Block *block = this->head->data;
    if (this->head == this->tail) {
        this->head = this->tail = nullptr;
        return block;
    }

    BlocksListNode *poped_node = this->head;
    this->head = this->head->next;
    delete poped_node;

    return block;
}

void BlocksList::del(Block *elem)
{
    if (this->head->data == elem) {
        if (this->head == this->tail) {
            this->tail = nullptr;
        }
        this->head = this->head->next;
        return;
    }

    BlocksListNode *node = this->head;
    while (node != nullptr) {
        if (node->next->data == elem) {
            if (node->next == this->tail) {
                this->tail = node;
            }
            BlocksListNode *deleting_node = node->next;
            node->next = deleting_node->next;
            delete deleting_node;
            return;
        }
        node = node->next;
    }
}


bool BlocksList::is_empty()
{
    if (this->head == nullptr) {
        return true;
    }
    return false;
}


int BlocksList::len()
{
    int len = 0;
    BlocksListNode *node = this->head;
    while (node != nullptr) {
        len++;
        node = node->next;
    }
    return len;
}