clc;
clear all;
close all;

%% ������ݶ�ȡ
data=xlsread('ssa-H.xlsx','Sheet1'); %%ʹ��xlsread������ȡEXCEL�ж�Ӧ��Χ�����ݼ���
data=data(1:14,:);


iter=100;

[gBest,gBestScore,cg_curve] = sol(data(:,1)');
fprintf('ָ��%d�Ľ���Ϊ��%.2f\n',1,gBest);
[~, x_pr]=GM(data(:,1)', gBest, 1);


% legend(gca,'show');


% createfigure(1:length(data),[data;x_p]);



















