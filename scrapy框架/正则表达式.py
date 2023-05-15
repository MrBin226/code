import re

# 1、从一个字符串中提取到所有的数字
# lst = re.findall(r"\d+", "我今年52岁，我喜欢10个明显")
# print(lst)

# 2、判断一句话中是否有数字
# search的特点：匹配字符串，匹配到第一个结果就返回，不会匹配出多个结果来
# res = re.search(r"\d+", "我今年52岁，我喜欢10个明显")
# print(res.group())

# finditer：所有的数据都会进行匹配，返回的是迭代器
# it = re.finditer(r"\d+", "我今年52岁，我喜欢10个明显")
# for item in it:
#     print(item.group())

# match 匹配，从头开始匹配，表示默认给正则表达式前面加^
# result = re.match(r"\d+", "52岁，我喜欢10个明显")
# print(result.group())

# result = re.split(r'\d+', "你好18岁的先生，我特别喜欢5米的")  # 表示按照数字去切割
# print(result)   # ['你好', '岁的先生，我特别喜欢', '米的']
# result = re.split(r'[你的]', "你好18岁的先生，我特别喜欢5米的")  # 按照你和的去切割
# print(result)   # ['', '好18岁', '先生，我特别喜欢5米', '']

# result = re.sub(r'\d+', '_sb_', "admin18我的天123啊啊的")     # 将一串连续数字替换为_sb_
# print(result)   # admin_sb_我的天_sb_啊啊的



