from time import time
import matplotlib.pyplot as plt


class Crypt:

    def enc(self, msg, number):
        msg_size = len(msg)
        key = (msg_size - 1) // number + 1
        res_str = [" ", ] * number * key
        for i in range(msg_size):
            index = abs(i // key) + abs(number * (i % key))
            res_str[index] = msg[i]
        return "".join(res_str)

    def dec(self, msg, number):
        msg_size = len(msg)
        key = (msg_size - 1) // number + 1
        return self.enc(msg, key)

    def create_files(self, filename, number, decrypt=False):
        with open(filename, "r", encoding="utf-8") as f:
            text = f.read()
        if not decrypt:
            tmp = self.enc(text, number)
            new_filename = filename[:-4] + "_encrypted.txt"
        else:
            tmp = self.dec(text, number)
            new_filename = filename[:-4] + "_decrypted.txt"

        with open(new_filename, "w", encoding="utf-8") as f:
            f.write(tmp)


def calc_resit(msg):
    msg_size = len(msg)
    count_ops = 0
    results = []
    for m in range(1, msg_size):
        num = (msg_size - 1) // m + 1
        res = [" ", ] * m * num
        count_ops += 2
        for j in range(msg_size):
            index = abs(m * (j % num)) + abs(j // num)
            count_ops += 2
            res[index] = msg[j]
        results.append("".join(res))
    return results, count_ops


def make_plot(fr, to, ax):
    plt.plot(range(fr, to), ax, color='black')
    plt.show()


if __name__ == '__main__':
    crypt = Crypt()
    crypt.create_files("test1.txt", 10, decrypt=False)
    crypt.create_files("test2.txt", 10, decrypt=True)

    y = []
    for i in range(5, 505):
        start = time()
        crypt.dec("x" * i, 5)
        end = time()
        y.append(end - start)

    make_plot(5, 505, y)

    y = []
    for i in range(1, 501):
        start = time()
        crypt.dec("x" * 500, i)
        end = time()
        y.append(end - start)

    make_plot(1, 501, y)

    y = []
    for i in range(1, 501):
        start = time()
        calc_resit("x" * i)
        end = time()
        y.append(end - start)

    make_plot(1, 501, y)
