import matplotlib.pyplot as plt

fig, gnt = plt.subplots()

gnt.set_xlim(0, 110)
gnt.set_ylim(0, 16)

gnt.set_xlabel('Time')
gnt.set_ylabel('Processors')

gnt.set_yticks([i for i in range(16)])
gnt.set_yticklabels([str(i) for i in range(16)])
#               #time      #node
gnt.broken_barh([(0, 2)], (0, 1), facecolors=('tab:orange'))
gnt.broken_barh([(0, 3)], (1, 1), facecolors=('tab:red'))
gnt.broken_barh([(0, 3)], (2, 1), facecolors=('tab:pink'))
gnt.broken_barh([(0, 1)], (3, 1), facecolors=('tab:gray'))
gnt.broken_barh([(0, 2)], (4, 1), facecolors=('tab:blue'))
gnt.broken_barh([(0, 1)], (5, 1), facecolors=('tab:orange'))

gnt.broken_barh([(5, 7)], (6, 1), facecolors=('tab:red'))
gnt.broken_barh([(8, 23)], (7, 1), facecolors=('tab:pink'))
gnt.broken_barh([(3, 17)], (8, 1), facecolors=('tab:gray'))
gnt.broken_barh([(3, 10)], (9, 1), facecolors=('tab:blue'))
gnt.broken_barh([(1, 12)], (10, 1), facecolors=('tab:orange'))

gnt.broken_barh([(12+31, 7)], (11, 1), facecolors=('tab:red'))
gnt.broken_barh([(31+13, 10)], (12, 1), facecolors=('tab:pink'))

gnt.broken_barh([(50+44, 10)], (13, 1), facecolors=('tab:gray'))
gnt.broken_barh([(44+20+13, 9)], (14, 1), facecolors=('tab:blue'))

gnt.grid(True)
plt.savefig("gantt1.png")
