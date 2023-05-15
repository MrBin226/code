import numpy as np
import random

"""
拥挤距离计算
输入：
funScore=np.array([[1,2], [2,3], [2,2], [3,2], [4,3], [2,1], [3,1], [3,2], [3,3], [3,4]])
layerDict
{1: [4, 9], 2: [8], 3: [1, 3, 7], 4: [2, 6], 5: [0, 5]}
indicate 第五层 个体索引 [0, 5]
"""

import numpy as np

"""
        支配关系字典 r_dict
        建立 {个体号码：[支配其的个数， 被其支配的个体列表]}
"""


def dominance(funScore):
    # 支配关系字典
    r_dict = {}

    # 需要建立支配关系的 个体数
    N = funScore.shape[0]

    # 建立个体索引 向量
    indicateVector = np.arange(N)

    # 建立 元素全为1 的 列向量
    oneVector = np.array([1] * N).reshape(N, 1)

    for k in range(N):
        # 建立 行向量全为 第k个个体评分的 矩阵
        oneMatrix = oneVector * funScore[k,]

        # 建立支配关系判断的 差分矩阵
        diffMatrix = funScore - oneMatrix

        greaterMatrix = np.vstack((diffMatrix[:, 0] >= 0, diffMatrix[:, 1] <= 0)).T
        lessMatrix = np.vstack((diffMatrix[:, 0] <= 0, diffMatrix[:, 1] >= 0)).T
        equalMatrix = (diffMatrix == 0)

        greaterVector = np.all(greaterMatrix, axis=1)
        lessVector = np.all(lessMatrix, axis=1)
        equalVector = np.all(equalMatrix, axis=1)

        # 建立非支配、支配向量
        dominate = indicateVector[greaterVector ^ equalVector,]
        nonDominate = indicateVector[lessVector ^ equalVector,]

        # 建立支配关系字典
        r_dict[k] = [len(nonDominate), list(dominate)]

    return r_dict


if __name__ == "__main__":
    funScore = np.array([[1, 4], [2, 3], [4, 3]], [2, 2.5])
    print(dominance(funScore))

