"""
对于一个完全二叉树，以每个节点为顶点的支数，该节点为最大值，叫做大根堆，反之为小根堆
对于一个完全二叉树，节点索引为i的父节点索引为(i-1)/2，左子节点索引为：2*i+1, 右子节点索引为:2*i+2

"""


def heapSort(arr):
    if arr is None or len(arr) < 2:
        return
    for i in range(len(arr)):
        heapInsert(arr, i)
    heapSize = len(arr) - 1
    arr[0], arr[-1] = arr[-1], arr[0]
    while heapSize > 0:
        heapify(arr, 0, heapSize)
        heapSize -= 1
        arr[0], arr[heapSize] = arr[heapSize], arr[0]


# 往一个大根堆上加入一个数，继续维持大根堆
def heapInsert(arr, index):
    while arr[index] > arr[int((index - 1) / 2)]:
        arr[index], arr[int((index - 1) / 2)] = arr[int((index - 1) / 2)], arr[index]
        index = int((index - 1) / 2)


# 某个数在index位置上，能否往下移，形成大根堆
def heapify(arr, index, heapSize):
    left = index * 2 + 1
    while left < heapSize:
        largest = left + 1 if arr[left + 1] > arr[left] and left + 1 < heapSize else left
        largest_idx = largest if arr[largest] > arr[index] else index
        if largest_idx == index:
            break
        arr[largest_idx], arr[index] = arr[index], arr[largest_idx]
        index = largest_idx
        left = index * 2 + 1


if __name__ == '__main__':

    a = [3,2,1,1,0,5]
    i = 0
    for n in range(1, 4):
        a[i:i+2] = a[i:i+2][::-1]
        i += 2
    # heapSort(a)
    print(a)

