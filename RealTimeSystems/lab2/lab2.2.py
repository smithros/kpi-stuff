import random
import matplotlib.pyplot as plt
import numpy as np
from math import *

n, omega, N = 12, 2400, 1024


def show_graphic(num: int, signal: list, title: str):
    plt.plot(list(range(0, num)), signal)
    plt.grid(True)
    plt.title(title)
    plt.show()


def show_imag_real(num: int, array: list, title: str):
    plt.plot(list(range(0, num)), np.real(array))
    plt.plot(list(range(0, num)), np.imag(array))
    plt.grid(True)
    plt.title(title)
    plt.show()


def random_signal():
    all_harm = []

    for i in range(n):
        A = random.randint(0, 100)
        phi = random.randint(0, 10)

        single_harm = []

        for j in range(N):
            y = A * sin(((omega * (n - i)) / n) * j + phi)
            single_harm.append(y)
        all_harm.append(single_harm)

    harm_sum = []

    for k in range(N):
        sum_num = 0
        for l in range(n):
            sum_num += all_harm[l][k]
        harm_sum.append(sum_num)
    return harm_sum


def math_wait(rang: int, signal: list):
    res = 0
    for p in range(rang):
        res += signal[p]
    return res / rang


def dispersion(rang: int, signal: list, mx):
    res = 0
    for p in range(rang):
        res += pow(signal[p] - mx, 2)
    return res / rang


def calc_r(rang: int, sig1: list, sig2: list, m1, m2):
    res = []
    for k in range(rang):
        r = 0
        for j in range(rang):
            r += (sig1[j] - m1) * (sig2[j + k] - m2)
        res.append(r / (rang - 1))
    return res


# Lab 2.1
def dft(rang: int, sig1: list):
    dft_res = []
    for i in range(rang):
        real_part = 0
        im_part = 0
        for j in range(rang):
            real_part += sig1[j] * cos(2 * pi * i * j / rang)
            im_part += sig1[j] * sin(2 * pi * i * j / rang)
        f_p = sqrt(pow(real_part, 2) + pow(im_part, 2))
        dft_res.append(f_p)
    return dft_res


# Lab 2.2
def fft_custom(data):
    n_fft = int(N / 2) - 1
    result_fft = []

    for i in range(N):
        rp1, im1 = 0, 0
        rp2, im2 = 0, 0

        for j in range(n_fft):
            rp1 += data[2 * j] * cos(4 * pi * i * j / N)
            im1 += data[2 * j] * sin(4 * pi * i * j / N)
            rp2 += data[2 * j + 1] * cos(4 * pi * i * j / N)
            im2 += data[2 * j + 1] * sin(4 * pi * i * j / N)

        re_all = cos(2 * pi * i / N)
        im_all = sin(2 * pi * i / N)
        w_all = sqrt(pow(re_all, 2) + pow(im_all, 2))

        if i < n_fft:
            f_p_real = rp1 + rp2 * w_all
            f_p_im = im1 + im2 * w_all
            f_p = sqrt(pow(f_p_real, 2) + pow(f_p_im, 2))
        else:
            f_p_real = rp1 - rp2 * w_all
            f_p_im = im1 - im2 * w_all
            f_p = sqrt(pow(f_p_real, 2) + pow(f_p_im, 2))
        result_fft.append(f_p)

    return result_fft


if __name__ == "__main__":
    sig1 = random_signal()
    sig2 = random_signal()
    sig_z = random_signal()

    m1 = math_wait(N, sig1)
    m2 = math_wait(N, sig2)
    disp = dispersion(N, sig1, m1)
    N2 = int(N / 2) - 1

    rxx = calc_r(N2, sig1, sig1, m1, m1)
    rxy = calc_r(N2, sig1, sig2, m1, m2)

    dft_arr = dft(N, sig1)
    fft_arr = fft_custom(sig1)
    fft_numpy = np.fft.fft(np.array(sig1))

    difference = np.real(fft_numpy) - fft_arr

    show_graphic(N, dft_arr, 'DFT')
    show_graphic(N, fft_arr, 'FFT-custom')
    show_imag_real(N, fft_numpy, 'FFT-numpy1')

    # Графіки відрізняються тільки уявною частиною,
    # бо в кастомній реалізації, вона конвертується в дійсну
    show_graphic(N, difference, 'Diff')
