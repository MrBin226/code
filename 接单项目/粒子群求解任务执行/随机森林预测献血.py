#!/usr/bin/env python
# coding: utf-8

# In[57]:


from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文

# In[25]:


data = pd.read_excel("E:\python代码\随机森林\数据.xlsx",sheet_name="Sheet2")
print(data.head())


# In[36]:


encode_data = data.apply(lambda x: LabelEncoder().fit_transform(x))
print(encode_data)


# In[37]:


label_data = data.apply(lambda x: LabelEncoder().fit(x).classes_)
print(label_data)


# In[50]:


predict_data = encode_data.iloc[:,encode_data.columns != "对于参加献血的态度"]
predict_target = encode_data.loc[:,"对于参加献血的态度"]


# In[59]:


# 划分训练集和测试集，比例是0.3
Xtrain,Xtest,Ytrain,Ytest = train_test_split(predict_data,predict_target,test_size=0.3)


# In[64]:


# 实例化模型
rfc = RandomForestClassifier(n_estimators=100,random_state=0)
# 训练模型
rfc = rfc.fit(Xtrain,Ytrain)
# 导入测试集测试模型
score_r = rfc.score(Xtest,Ytest)
print("randomforest：{}".format(score_r))


# In[65]:


# 各个属性的贡献程度
print(rfc.feature_importances_)
# 如果需要对模型进行预测数据使用predict(x)，x为输入数据
# rfc.predict(x)


# In[68]:


x = rfc.feature_importances_


# In[71]:


y = predict_data.columns
y = y[np.argsort(x)]


# In[75]:

plt.figure(figsize=(12, 8), dpi=80)
plt.scatter(sorted(x),y)
plt.xlabel("Gini importance")
plt.show()


# In[ ]:





