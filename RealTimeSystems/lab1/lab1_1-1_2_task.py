from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
import math
import random
import timeit
import matplotlib.pyplot as plt

google_auth = GoogleAuth()
google_auth.LocalWebserverAuth()
drive = GoogleDrive(google_auth)

n, omega, N = 10, 2700, 768

result = ''
result22 = ''


def file_upload(name: str, content: str):
    created_file = drive.CreateFile({'title': name})
    created_file.SetContentString(content)
    created_file.Upload()


def show_graphic(num: int, signal: list):
    plt.plot(list(range(0, num)), signal)
    plt.grid(True)
    plt.show()


def random_signal():
    all_harm = []

    for i in range(n):
        A = random.randint(0, 100)
        phi = random.randint(0, 10)

        single_harm = []

        for j in range(N):
            y = A * math.sin(((omega * (n - i)) / n) * j + phi)
            single_harm.append(y)
        all_harm.append(single_harm)

    harm_sum = []

    for k in range(N):
        sum_num = 0
        for l in range(n):
            sum_num += all_harm[l][k]
        harm_sum.append(sum_num)
    return harm_sum


sig1 = random_signal()
sig2 = random_signal()

start_mx = timeit.default_timer()
m1 = 0
for i in range(N):
    m1 += sig1[i]
m1 = m1 / N
end_mx = timeit.default_timer()

m2 = 0
for i in range(N):
    m2 += sig2[i]
m2 = m2 / N

mx_time = end_mx - start_mx
result1 = "Mx = " + str(m1) + ", time = " + str(mx_time) + " seconds"

print(result1)

start_disp = timeit.default_timer()
disp = 0
for i in range(N):
    disp += math.pow(sig1[i] - m1, 2)
disp = disp / N
end_disp = timeit.default_timer()

disp_time = end_disp - start_disp
result2 = "\nDx = " + str(disp) + ", time = " + str(disp_time) + " seconds"

print(result2)

N2 = int(N / 2) - 1
start_rxx = timeit.default_timer()
rxx = []
for i in range(N2):
    r = 0
    for j in range(N2):
        r += (sig1[j] - m1) * (sig1[j + i] - m1)
    rxx.append(r / (N2 - 1))
end_rxx = timeit.default_timer()

rxx_time = end_rxx - start_rxx
result3 = "Rxx time = " + str(rxx_time) + " seconds"
print("Rxx = ", rxx, ", time = ", end_rxx - start_rxx, " seconds")

start_rxy = timeit.default_timer()
rxy = []
for i in range(N2):
    r = 0
    for j in range(N2):
        r += (sig1[j] - m1) * (sig2[j + i] - m2)
    rxy.append(r / (N2 - 1))
end_rxy = timeit.default_timer()

rxy_time = end_rxy - start_rxy
result4 = "\nRxy time = " + str(rxy_time) + " seconds"
print("Rxy = ", rxy, ", time = ", end_rxy - start_rxy, " seconds")

result = result1 + result2
result22 = result3 + result4


# show_graphic(N, sig1)
# show_graphic(N2, rxx)
# show_graphic(N2, rxy)


def d_min_mx(l_list: list, sgnal: list):
    mx = 0
    disp_new = 0

    for i in range(len(l_list)):
        mx += sgnal[i]
    mx = mx / len(l_list)

    for j in range(len(l_list)):
        disp_new += math.pow(sgnal[j] - mx, 2)

    return disp_new - mx


d_minus_mx = []
new_signals = []
N_new = list(range(256, 1024))

for i in range(N):
    rand_signal = random_signal()
    new_signals.append(rand_signal)
    d_minus_mx.append(d_min_mx(N_new, rand_signal))

plt.plot(N_new, new_signals)
plt.grid(True)
plt.show()

file_upload('Lab1-1.txt', result)
file_upload('Lab1-2.txt', result22)
