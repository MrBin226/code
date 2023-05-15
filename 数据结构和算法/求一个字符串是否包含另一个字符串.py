def KMP(s1, s2):
    if not s1 or not s2 or len(s1) < len(s2):
        return -1

    def getnextarray(s):
        if len(s) == 1:
            return [-1]
        next = [0] * len(s)
        next[0], next[1] = -1, 0
        cn = 0
        i = 2
        while i < len(s):
            if s[i - 1] == s[cn]:
                next[i] = cn + 1
                i += 1
                cn += 1
            elif cn == 0:
                next[i] = 0
                i += 1
            else:
                cn = next[i]
        return next

    next = getnextarray(s2)
    i1, i2 = 0, 0
    while i1 < len(s1) and i2 < len(s2):
        if s1[i1] == s2[i2]:
            i1 += 1
            i2 += 1
        elif next[i2] == -1:
            i1 += 1
        else:
            i2 = next[i2]
    return i1 - i2 if i2 == len(s2) else -1, next

if __name__ == '__main__':
    s1 = "hello"
    s2 = "llo"
    print(KMP(s1, s2))

