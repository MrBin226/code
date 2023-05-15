# 0.03650500000000534
from geopy.distance import geodesic

x = [114.055656, 22.56236]
y = [114.092161, 22.563052]
print(geodesic(x[::-1], y[::-1]).km)

