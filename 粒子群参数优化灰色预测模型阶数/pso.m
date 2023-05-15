clc;
clear all;
close all;

%% 相关数据读取
data=xlsread('ssa-H.xlsx','Sheet1'); %%使用xlsread函数读取EXCEL中对应范围的数据即可
data=data(1:14,:);


iter=100;

[gBest,gBestScore,cg_curve] = sol(data(:,1)');
fprintf('指标%d的阶数为：%.2f\n',1,gBest);
[~, x_pr]=GM(data(:,1)', gBest, 1);


% legend(gca,'show');


% createfigure(1:length(data),[data;x_p]);



















