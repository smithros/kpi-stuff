import math

from ellipticcurve.ecdsa import Ecdsa
from ellipticcurve.privateKey import PrivateKey


def get_key(file_path: str):
    f = open(file_path, "r")
    inp = f.read()
    return PrivateKey().fromPem(inp)


def gen_sign(msg: str, pr_key):
    return Ecdsa.sign(msg, pr_key)


def verify(msg: str, sign, pb_key):
    return Ecdsa.verify(msg, sign, pb_key)


def brute(bit_num: int):
    product = math.pow(2, bit_num - 1)

    if product < math.pow(2, bit_num):
        product += 1
        for i in range(2, int(product)):
            if (product % i) == 0:
                print([x for x in range(1, int(product))])
            else:
                break
    else:
        pass


if __name__ == '__main__':
    pr_key = get_key('public_key.pem')
    publicKey = pr_key.publicKey()
    print(publicKey.toPem())
    message = "Cryptography test"
    print("Message: ", message)
    signature = gen_sign(message, pr_key)
    print("Signature: ", signature.toBase64())
    print("Is message authentic? - ", verify(message, signature, publicKey))
