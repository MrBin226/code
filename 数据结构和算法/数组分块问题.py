"""
1、对于一个数组，给定一个数num，让小于等于num的在数组左边，大于num的在数组右边
2、对于一个数组，给定一个数num，让小于num的在数组左边，等于num的在数组中间，大于num的在数组右边

"""

def test1(arr, num):
    p1 = 0
    for i in range(1, len(arr)):
        if arr[i] <= num:
            arr[i], arr[p1+1] = arr[p1+1], arr[i]
            p1 += 1


def test2(arr, num):
    p1 = -1
    p2 = len(arr)
    i = 0
    while i < len(arr):
        if i == p2:
            break
        if arr[i] < num:
            arr[i], arr[p1 + 1] = arr[p1 + 1], arr[i]
            i += 1
            p1 += 1
        elif arr[i] > num:
            arr[i], arr[p2 - 1] = arr[p2 - 1], arr[i]
            p2 -= 1
        else:
            i += 1


if __name__ == '__main__':
    a = [3,2,5,8,6,5,7,2]
    # test1(a,5)
    test2(a, 5)
    print(a)