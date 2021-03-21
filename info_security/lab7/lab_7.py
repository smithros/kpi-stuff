import rsa

if __name__ == '__main__':
    (public_key, private_key) = rsa.newkeys(1024)
    print("Private key: \n", private_key)
    print("Public key: \n", public_key)
    message = 'A computer would deserve to be called intelligent'
    print("Start text", message)
    encrypted = rsa.encrypt(bytes(message, 'utf-8'), public_key)
    print("Encrypted text: \n", encrypted)
    decrypted = rsa.decrypt(encrypted, private_key)
    print("Decrypted text: \n", decrypted)
