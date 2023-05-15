# 选择排序算法：时间复杂度O(n^2)
def selectSort(arr):
    if arr is None or len(arr) < 2:
        return
    for i in range(len(arr) - 1):
        minIndex = i
        for j in range(i + 1, len(arr)):
            minIndex = j if arr[j] < arr[minIndex] else minIndex
        arr[i], arr[minIndex] = arr[minIndex], arr[i]


# 冒泡排序算法：时间复杂度O(n^2)
def bubbleSort(arr):
    if arr is None or len(arr) < 2:
        return
    for i in range(len(arr) - 1, 0, -1):
        for j in range(i):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]


# 插入排序算法: 最好情况O(N),最坏情况O(N^2)
def insertSort(arr):
    if arr is None or len(arr) < 2:
        return
    for i in range(1, len(arr)):
        for j in range(i - 1, -1, -1):
            if arr[j] > arr[j + 1]:
                arr[j + 1], arr[j] = arr[j], arr[j + 1]
            else:
                break


# 归并排序算法：时间复杂度O(NlogN)
def mergeSort(arr):
    if arr is None or len(arr) < 2:
        return

    def merge(arr, L, mid, R):
        temp = []
        p1 = L
        p2 = mid+1
        while p1 <= mid and p2 <= R:
            if arr[p2] < arr[p1]:
                temp.append(arr[p2])
                p2 += 1
            else:
                temp.append(arr[p1])
                p1 += 1
        while p1 <= mid:
            temp.append(arr[p1])
            p1 += 1
        while p2 <= mid:
            temp.append(arr[p2])
            p2 += 1
        for i in range(len(temp)):
            arr[L + i] = temp[i]

    def process(arr, L, R):
        if L == R:
            return
        mid = L + ((R - L) >> 1)
        process(arr, L, mid)
        process(arr, mid+1, R)
        merge(arr, L, mid, R)

    process(arr, 0, len(arr) - 1)


# 快速排序算法：平均时间复杂度O(NlogN)
import random
def quickSort(arr):
    if arr is None or len(arr) < 2:
        return

    def partition(arr, L, R):
        p1 = L - 1
        p2 = R
        i = L
        while i < p2:
            if arr[i] < arr[R]:
                arr[p1 + 1], arr[i] = arr[i], arr[p1 + 1]
                p1 += 1
                i += 1
            elif arr[i] == arr[R]:
                i += 1
            else:
                arr[p2 - 1], arr[i] = arr[i], arr[p2 - 1]
                p2 -= 1
        arr[R], arr[p2] = arr[p2], arr[R]
        return p1, p2 + 1

    def process(arr, L, R):
        if L >= R:
            return
        t = random.randint(L, R)
        arr[t], arr[R] = arr[R], arr[t]
        p1, p2 = partition(arr, L, R)
        process(arr, L, p1)
        process(arr, p2, R)

    process(arr, 0, len(arr) - 1)


data = []
def test(arr):
    if arr is None or len(arr) < 2:
        return

    def merge(arr, L, mid, R):
        global data
        temp = []
        p1 = L
        p2 = mid + 1
        while p1 <= mid and p2 <= R:
            if arr[p2] < arr[p1]:
                temp.append(arr[p2])
                for k in range(p1, mid+1):
                    data.append((arr[k], arr[p2]))
                p2 += 1
            else:
                temp.append(arr[p1])
                p1 += 1
        while p1 <= mid:
            temp.append(arr[p1])
            p1 += 1
        while p2 <= mid:
            temp.append(arr[p2])
            p2 += 1
        for i in range(len(temp)):
            arr[L + i] = temp[i]

    def process(arr, L, R):
        if L == R:
            return
        mid = L + ((R - L) >> 1)
        process(arr, L, mid)
        process(arr, mid + 1, R)
        merge(arr, L, mid, R)

    process(arr, 0, len(arr) - 1)
    return data


if __name__ == '__main__':
    a = [3,2,5,6,7,5,2,5]
    # selectSort(a)
    # bubbleSort(a)
    # insertSort(a)
    # mergeSort(a)
    quickSort(a)
    # print(test(a))

    print(a)
