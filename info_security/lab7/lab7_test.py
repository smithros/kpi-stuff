import time

def enc_test():
    y = []
    for i in range(1, 101):
        (pb, pr) = rsa.newkeys(1024)
        t1 = time.time()
        rsa.encrypt(bytes("a" * i, 'utf-8'), pb)
        t2 = time.time()
        y.append(t2 - t1)
    return y


def dec_test():
    y = []
    for i in range(1, 5):
        (pb, pr) = rsa.newkeys(1024)
        enc = rsa.encrypt(bytes("a" * i, 'utf-8'), pb)
        t1 = time.time()
        rsa.decrypt(enc, pr)
        t2 = time.time()
        y.append(t2 - t1)
    return y


if __name__ == '__main__':
    print(enc_test())
    print(dec_test())
