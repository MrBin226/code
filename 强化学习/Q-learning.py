import numpy as np
import gym
import random

env = gym.make("Taxi-v3", render_mode="human")

action_size = env.action_space.n  # 获取动作维度（一个状态下有几种动作选择）
print("Action size ", action_size)

state_size = env.observation_space.n  # 获取状态维度（一共多少种状态）
print("State size ", state_size)

qtable = np.zeros((state_size, action_size))  # 初始化 Q 表

total_episodes = 50000  # 一共玩多少局游戏
total_test_episodes = 100  # 测试中一共走几步
max_steps = 99  # 每一局游戏最多走几步

learning_rate = 0.7  # 学习率
gamma = 0.618  # 未来奖励折扣率

# 探索相关参数
epsilon = 1.0  # 探索概率
max_epsilon = 1.0  # 一开始的探索概率
min_epsilon = 0.01  # 最低的探索概率
decay_rate = 0.01  # 探索概率的指数衰减概率

# 循环 50000 局游戏
for episode in range(total_episodes):
    # 重置环境
    state = env.reset()[0]
    step = 0
    done = False

    for step in range(max_steps):  # 每一局游戏最多 99 步
        # 3. Choose an action a in the current world state (s)
        ## 生成 0～1 之间的随机数
        exp_exp_tradeoff = random.uniform(0, 1)

        ## 如果这个数字大于 探索概率（开始时为 1），则进行开发（选择最大 Q 的动作）
        if exp_exp_tradeoff > epsilon:
            action = np.argmax(qtable[state, :])

        ## 否则，进行探索（选择随机动作）
        else:
            action = env.action_space.sample()

        # 这个动作与环境交互后，获得奖励，环境变成新的状态
        new_state, reward, done, _, _ = env.step(action)

        # 按照公式 Q(s,a):= Q(s,a) + lr [R(s,a) + gamma * max Q(s',a') - Q(s,a)] 更新 Q 表
        qtable[state, action] = qtable[state, action] + learning_rate * (reward + gamma *
                                                                         np.max(qtable[new_state, :]) - qtable[
                                                                             state, action])


        # 迭代环境状态
        state = new_state

        # 如果游戏结束，则跳出循环
        if done:
            break

    # 减小探索概率（由于不确定性越来越小）
    epsilon = min_epsilon + (max_epsilon - min_epsilon) * np.exp(-decay_rate * episode)

print("训练完成")

env.reset()
rewards = []

for episode in range(total_test_episodes):
    state = env.reset()
    step = 0
    done = False
    total_rewards = 0
    print("****************************************************")
    print("EPISODE ", episode)

    for step in range(max_steps):
        env.render()
        # 测试中我们就不需要探索了，只要选择最优动作
        action = np.argmax(qtable[state, :])

        new_state, reward, done, _, _ = env.step(action)

        total_rewards += reward

        if done:
            rewards.append(total_rewards)
            print("Score", total_rewards)
            break
        state = new_state
env.close()
print("Score over time: " + str(sum(rewards) / total_test_episodes))

