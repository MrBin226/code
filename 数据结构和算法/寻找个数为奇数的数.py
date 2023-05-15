"""
1、一个列表里，只有一个数是奇数个，剩下的数都是偶数个，寻找这个数
2、一个列表里，只有两个数是奇数个，剩下的数都是偶数个，寻找这两个数
"""

def find_1_num(arr):
    num = 0
    for i in range(len(arr)):
        num = num ^ arr[i]
    return num


def find_2_num(arr):
    num = 0
    for i in range(len(arr)):
        num = num ^ arr[i]
    rightone = num & (~num + 1)  # 找到一个数，二进制里最右侧的1，其余都为0
    onlyone = 0
    for i in range(len(arr)):
        if (arr[i] & rightone) == 0:
            onlyone ^= arr[i]
    return onlyone, onlyone ^ num


if __name__ == '__main__':
    a = [1,1,2,3,3,2,2,4,4]
    b = [1,1,2,3,2,2,4,4]
    print(find_1_num(a))
    print(find_2_num(b))