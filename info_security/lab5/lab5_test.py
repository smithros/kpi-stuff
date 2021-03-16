import matplotlib.pyplot as plt
import time
from lab5 import *


def make_plot(fr: int, to: int, ax: list):
    plt.plot(range(fr, to), ax)
    plt.show()


key = generate_rand_key()
msg = 'Захист інформації у компютерних системах.'
print(f"Chiper key  = {key}")
print(f"Chiper text : {msg}")
enc_str = encrypt(encrypt(msg, key), key)
dec_str = decrypt(decrypt(enc_str, key), key)
print(f"Twice encrypted message: {enc_str}")
print(f"Twice decrypted message: {dec_str}")
bruted = brute('ТхсгФл0П9КЦ5СхДП70ц0вЦСяХли59гс0ФгФлиСхсй')

in_enc = 'in_enc.docx'
in_dec = 'in_dec.docx'
out_enc = 'out_enc.docx'
out_dec = 'out_dec.docx'

enc_text = read_docx(in_enc)
dec_text = read_docx(in_dec)

key2 = generate_rand_key()
encrypt_file_text = encrypt(encrypt(enc_text, key2), key2)
write_docx(out_enc, encrypt_file_text)

key3 = 7777
decrypt_file_text = decrypt(dec_text, key3)
write_docx(out_dec, decrypt_file_text)

print(f'\nText to encrypt: {enc_text}')
print(f"Chiper key = {key2}")
print(f'Encrypted text: {encrypt_file_text}')
print(f'\nText to decrypt: {dec_text}')
print(f"Chiper key = {key3}")
print(f'Decrypted text: {decrypt_file_text}')

all_keys = get_all_keys()


def test_enc_1():
    y = []
    for i in range(2, 400):
        t1 = time.time()
        encrypt(encrypt('є' * i, 1234), 1234)
        t2 = time.time()
        y.append(t2 - t1)
    return y


make_plot(2, 400, test_enc_1())


def test_enc_2():
    res = []
    for i in range(2, len(all_keys), 5):
        t1 = time.time()
        encrypt(encrypt('є' * 200, all_keys[i]), all_keys[i])
        t2 = time.time()
        res.append(t2 - t1)
    return res


plt.plot(range(2, len(all_keys), 5), test_enc_2())
plt.show()


def test_dec_1():
    res = []
    for i in range(2, 400):
        t1 = time.time()
        decrypt(decrypt('є' * i, 1234), 1234)
        t2 = time.time()
        res.append(t2 - t1)
    return res


make_plot(2, 400, test_dec_1())


def test_dec_2():
    res = []
    for i in range(2, len(all_keys), 5):
        t1 = time.time()
        decrypt(decrypt('є' * 200, all_keys[i]), all_keys[i])
        t2 = time.time()
        res.append(t2 - t1)
    return res


plt.plot(range(2, len(all_keys), 5), test_dec_2())
plt.show()


def test_hack():
    res = []
    for i in range(2, 400):
        t1 = time.time()
        brute('є' * i)
        t2 = time.time()
        res.append(t2 - t1)
    return res


make_plot(2, 400, test_hack())
