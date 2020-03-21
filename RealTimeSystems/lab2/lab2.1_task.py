from math import *
import random
import timeit
import matplotlib.pyplot as plt

n, omega, N = 12, 2400, 1024

result = ''
result22 = ''


def show_graphic(num: int, signal: list, title: str):
    plt.plot(list(range(0, num)), signal)
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


def math_wait(N, signal):
    res = 0
    for p in range(N):
        res += signal[p]
    return res / N


def dispersion(N, signal, mx):
    res = 0
    for p in range(N):
        res += pow(signal[p] - mx, 2)
    return res / N


sig1 = random_signal()
sig2 = random_signal()
sig_z = random_signal()

start_mx = timeit.default_timer()
m1 = math_wait(N, sig1)
end_mx = timeit.default_timer()

m2 = math_wait(N, sig2)

mx_time = end_mx - start_mx
result1 = "Mx = " + str(m1) + ", time = " + str(mx_time) + " seconds"

print(result1)

start_disp = timeit.default_timer()
disp = dispersion(N, sig1, m1)
end_disp = timeit.default_timer()

disp_time = end_disp - start_disp
result2 = "\nDx = " + str(disp) + ", time = " + str(disp_time) + " seconds"

print(result2)

N2 = int(N / 2) - 1


def calc_r(N2, sig1, sig2, m1, m2):
    res = []
    for k in range(N2):
        r = 0
        for j in range(N2):
            r += (sig1[j] - m1) * (sig2[j + k] - m2)
        res.append(r / (N2 - 1))
    return res


start_rxx = timeit.default_timer()
rxx = calc_r(N2, sig1, sig1, m1, m1)
end_rxx = timeit.default_timer()
rxx_time = end_rxx - start_rxx

result3 = "Rxx time = " + str(rxx_time) + " seconds"
print("Rxx = ", rxx, ", time = ", end_rxx - start_rxx, " seconds")

start_rxy = timeit.default_timer()
rxy = calc_r(N2, sig1, sig2, m1, m2)
end_rxy = timeit.default_timer()
rxy_time = end_rxy - start_rxy

result4 = "\nRxy time = " + str(rxy_time) + " seconds"
print("Rxy = ", rxy, ", time = ", end_rxy - start_rxy, " seconds")

# Lab 2.1

start_f_normal_start = timeit.default_timer()
F = []
for i in range(N):
    real_part = 0
    im_part = 0
    for j in range(N):
        real_part += sig1[j] * cos(2 * pi * i * j / N)
        im_part += sig1[j] * sin(2 * pi * i * j / N)
    f_p = sqrt(pow(real_part, 2) + pow(im_part, 2))
    F.append(f_p)
f_normal_end = timeit.default_timer()

f_normal_time = f_normal_end - start_f_normal_start


def generate_table():
    all_values = []
    for i in range(N):
        all_fs = []
        for j in range(N):
            cos_sin_values = []
            cos_value = cos(2 * pi * i * j / N)
            sin_value = sin(2 * pi * i * j / N)
            cos_sin_values.append(cos_value)
            cos_sin_values.append(sin_value)
            all_fs.append(cos_sin_values)
        all_values.append(all_fs)
    return all_values


start_f_table_start = timeit.default_timer()


def use_table(table_input, signal1):
    table = []
    for i in range(N):
        real = 0
        img = 0
        for j in range(N):
            real += signal1[j] * table_input[i][j][0]
            img += signal1[j] * table_input[i][j][1]
        f_p = sqrt(pow(real, 2) + pow(img, 2))
        table.append(f_p)
    return table


f_table_end = timeit.default_timer()
f_table_time = f_table_end - start_f_table_start

print("F table time: ", f_table_time)
print("F normal time: ", f_normal_time)
print("Diff: ", f_table_time - f_normal_time)

table = generate_table()
f_new = use_table(table, sig1)

show_graphic(N, F, 'F')
show_graphic(N, f_new, 'F Table')
