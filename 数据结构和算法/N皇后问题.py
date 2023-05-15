class Solution:
    def solveNQueens(self, n: int):
        if n == 2 or n == 3:
            return []
        self.result = []
        for j in range(1, n + 1):
            res = []
            res.append((1, j))
            self.que = [-1] * n
            self.que[0] = j
            self.process(n, 2, res)

        return self.result

    def process(self, n, i, res):
        if i > n:
            temp = ["."] * n
            rr = []
            for k in self.que:
                temp[k - 1] = 'Q'
                rr.append(''.join(temp))
                temp[k - 1] = '.'
            self.result.append(rr)
            return
        for j in range(1, n + 1):
            if self.isvalid(i, j, res):
                res.append((i, j))
                self.que[i - 1] = j
                self.process(n, i + 1, res)
                res.remove((i, j))


    def isvalid(self, i, j, res):
        for r in res:
            if j == r[1] or (abs(i - r[0]) == abs(j - r[1])):
                return False
        return True

if __name__ == '__main__':
    print(Solution().solveNQueens(5))