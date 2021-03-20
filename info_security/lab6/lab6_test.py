import time

from lab6.lab_6 import *


def eng_enc_test():
    y = []
    for el in range(1, 200):
        t1 = time.time()
        encrypt_start('one', 'two', 'three', 'z' * el, "eng")
        t2 = time.time()
        y.append(t2 - t1)
    return y


def eng_triple_enc_test():
    y = []
    for el in range(1, 200):
        for j in range(1, 200):
            for c in range(1, 200):
                t1 = time.time()
                encrypt_start('a' * el, 'b' * j, 'c' * c, 'z' * 200, 'eng')
                t2 = time.time()
                y.append(t2 - t1)
    return y


def eng_dec_test():
    y = []
    for el in range(1, 200):
        t1 = time.time()
        decrypt_start('one', 'two', 'three', 'msg' * el, 'eng')
        t2 = time.time()
        y.append(t2 - t1)
    return y


def eng_triple_dec_test():
    y = []
    for el in range(1, 200):
        for j in range(1, 200):
            for c in range(1, 200):
                t1 = time.time()
                decrypt_start('a' * el, 'b' * j, 'c' * c, 'z' * 200, 'eng')
                t2 = time.time()
                y.append(t2 - t1)
    return y


def ukr_enc_test():
    y = []
    for el in range(1, 200):
        t1 = time.time()
        encrypt_start('one', 'two', 'three', 'z' * el, "eng")
        t2 = time.time()
        y.append(t2 - t1)
    return y


def ukr_triple_enc_test():
    y = []
    for el in range(1, 200):
        for j in range(1, 200):
            for c in range(1, 200):
                t1 = time.time()
                encrypt_start('ф' * el, 'і' * j, 'й' * c, 'и' * 200, 'ukr')
                t2 = time.time()
                y.append(t2 - t1)
    return y


def ukr_dec_test():
    y = []
    for el in range(1, 200):
        t1 = time.time()
        decrypt_start('один', 'два', 'три', 'msg' * el, 'ukr')
        t2 = time.time()
        y.append(t2 - t1)
    return y


def ukr_triple_dec_test():
    y = []
    for el in range(1, 200):
        for j in range(1, 200):
            for c in range(1, 200):
                t1 = time.time()
                decrypt_start('ф' * el, 'і' * j, 'й' * c, 'и' * 200, 'ukr')
                t2 = time.time()
                y.append(t2 - t1)
    return y


if __name__ == '__main__':
    print("\nАнгл текст:\n")
    print(f"Залежність часу шифрування залежно від об’єму повідомлення: {eng_enc_test()}")
    print(f"Залежність часу шифрування залежно від параметрів шифру: {eng_triple_enc_test()}")
    print(f"Залежність часу дешифрування залежно від об’єму повідомлення: {eng_dec_test()}")
    print(f"Залежність часу дешифрування залежно від параметрів шифру: {eng_triple_dec_test()}")
    print(f"\nУкр текст:\n")
    print(f"Залежність часу шифрування залежно від об’єму повідомлення: {ukr_enc_test()}")
    print(f"Залежність часу шифрування залежно від параметрів шифру: {ukr_triple_enc_test()}")
    print(f"Залежність часу дешифрування залежно від об’єму повідомлення: {ukr_dec_test()}")
    print(f"Залежність часу дешифрування залежно  від параметрів шифру: {ukr_triple_dec_test()}")
