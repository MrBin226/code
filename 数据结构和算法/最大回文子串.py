def process(s):
    if len(s) < 2:
        return s
    s1 = '#' + '#'.join(list(s)) + '#'
    next = [1] * len(s1)
    R = 0
    C = 0
    for i in range(1, len(s1)):
        if i > R or 2 * C - i > - 1:
            while i + next[i] < len(s1) and i - next[i] > -1:
                if s1[i + next[i]] == s1[i - next[i]]:
                    next[i] += 1
                else:
                    break
        else:
            if 2 * C - i - next[2 * C - i] + 1 > C - next[C] + 1:
                next[i] = next[2 * C - i]
            elif 2 * C - i - next[2 * C - i] + 1 < C - next[C] + 1:
                next[i] = R - C + 1
            else:
                next[i] = R - C + 1
                while i + next[i] < len(s1) and i - next[i] > -1:
                    if s1[i + next[i]] == s1[i - next[i]]:
                        next[i] += 1
                    else:
                        break
    idx = next.index(max(next))
    s2 = list(s1[int(idx - (next[idx] - 1) / 2):int(idx + (next[idx] - 1) / 2 + 1)])
    for i in range(0, len(s2), 2):
        s2[i] = ''

    return ''.join(s2)

def manacher(s):
    if len(s) < 2:
        return s
    s1 = '#' + '#'.join(list(s)) + '#'
    next = [1] * len(s1)
    R = 0
    C = 0
    i = 1
    while i < len(s1):
        if i > R:
            while i + next[i] < len(s1) and i - next[i] > -1:
                if s1[i + next[i]] == s1[i - next[i]]:
                    next[i] += 1
                else:
                    break
        else:
            if 2 * C - i - next[2 * C - i] < C - R:
                next[i] = next[2 * C - i]
            elif 2 * C - i - next[2 * C - i] > C - R:
                next[i] = R - i + 1
            else:
                next[i] = R - i + 1
                while i + next[i] < len(s1) and i - next[i] > -1:
                    if s1[i + next[i]] == s1[i - next[i]]:
                        next[i] += 1
                    else:
                        break
        if i + next[i] - 1 > R:
            R = next[i]
            C = i
        i += 1
    idx = next.index(max(next))
    s2 = list(s1[idx - next[idx] + 1:idx + next[idx]])
    for i in range(len(s2)):
        if i % 2 == 0:
            s2[i] = ""
    return ''.join(s2)


if __name__ == '__main__':
    print(manacher("babad"))
