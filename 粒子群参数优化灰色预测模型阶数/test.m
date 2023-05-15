clc;
clear all;
close all;

%% 相关数据读取
[data,name] = xlsread('所有值.xlsx','Sheet1','A2:I23');
[gBest,gBestScore,cg_curve] = sol(data(20,:));
best_f=gBestScore;
best_j=gBest;
for i=1:500
    disp(i)
    [gBest,gBestScore,cg_curve] = sol(data(20,:));
    if best_f>gBestScore
        best_f=gBestScore;
        best_j=gBest;
    end
end
fprintf('指标%d的最优阶数为：%.2f,误差为：%.2f\n',20,best_j,best_f);
[~, x_pr]=GM(data(20,:), best_j);
createfigure(1:length(data(20,:)),[data(20,:);x_pr]);
title([name{20}, '预测情况'])

