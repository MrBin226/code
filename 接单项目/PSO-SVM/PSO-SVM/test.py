import matplotlib.pyplot as plt


sca = plt.scatter(range(10),range(10))
sca.remove()
sca = plt.scatter(range(5),range(5))

plt.show()
