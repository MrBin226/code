def func(i, start, end, other):
    if i == 1:
        print(f"{i}:{start}->{end}")
    else:
        func(i-1, start, other, end)
        print(f"{i}:{start}->{end}")
        func(i-1, other, end, start)


if __name__ == '__main__':
    func(3, "左", "右", "中")
