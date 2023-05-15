import types
import queue

def have_circle(graph:  str) -> bool:
    route_str = graph.split(',')
    route = [list(map(int, res.split('->'))) for res in route_str]
    node = set()
    for res in route_str:
        temp = [*map(int, res.split('->'))]
        node.add(temp[0])
        node.add(temp[1])
    G = [[0 for _ in range(len(node))] for _ in range(len(node))]

    for res in route:
        G[res[0] - 1][res[1] - 1] = 1

    # have_cir = False
    #
    # def dfs(i, color):
    #     nonlocal have_cir
    #     color[i] = -1
    #     for j in range(num):
    #         if G[i][j] != 0:
    #             if color[j] == -1:
    #                 have_cir = True
    #                 break
    #             if color[j] == 1:
    #                 continue
    #             if color[j] == 0:
    #                 dfs(j, color)
    #     color[i] = 1
    #
    # num = len(node)
    # color = [0 for _ in range(num)]
    # for i in range(num):
    #     dfs(i, color)
    #     if have_cir:
    #         return True
    # return False

    degree = [0 for _ in range(len(node))]
    for i in range(len(node)):
        for j in range(len(node)):
            if G[i][j] != 0:
                degree[j] += 1
    que = queue.Queue()
    for i in range(len(node)):
        if degree[i] == 0:
            que.put(i)
    cnt = 0
    while not que.empty():
        cnt += 1
        root = que.get()

        for j in range(len(node)):
            if G[root][j] != 0:
                degree[j] -= 1
                if degree[j] == 0:
                    que.put(j)
    return cnt != len(node)


if __name__ == '__main__':
    graph = "1->4,2->5,3->6,3->7,4->8,5->8,5->9,6->9,6->11,7->11,8->12,9->12,9->13,10->13,10->14,11->10,11->14"
    print(have_circle(graph))