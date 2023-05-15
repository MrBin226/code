clc;
clear;
%load zx.txt %导入数据 %这是原来的程序
% 如果需要更换数据，只需要更改第5行的文件路径，39行的21代表是21个输入，也需要更改这个
zx = xlsread('200份有效样本编号A1~F3.xls');
jg=zx; %利用数据训练 BP 神经网络
%p=[jg(:,1),jg(:,2),jg(:,3),jg(:,4),jg(:,5),jg(:,6)];
p=jg;
% t=jg(:,7);
t=jg(:,end);
p=p';
t=t';
%% MIV 增加或者减少自变量
p=p';
[m,n]=size(p);
yy_temp=p;
% p_increase 为增加 10%的矩阵 p_decrease 为减少 10%的矩阵
for i=1:n
    p=yy_temp;
    pX=p(:,i);
    pa=pX*1.1;
    p(:,i)=pa;
    aa=['p_increase' int2str(i) '=p;'];
    eval(aa);
end
for i=1:n
    p=yy_temp;
    pX=p(:,i);
    pa=pX*0.9;
    p(:,i)=pa;
    aa=['p_decrease' int2str(i) '=p;'];
    eval(aa);
end
%% 利用原始数据训练一个正确的神经网络
nntwarn off;
p=yy_temp;
p=p';
% bp 网络建立
net=newff(minmax(p),[21,1],{'tansig','purelin'},'traingdm');
% 初始化 bp 网络
net=init(net);
% 网络训练参数设置
net.trainParam.show=50;
net.trainParam.lr=0.05;
net.trainParam.mc=0.9;
net.trainParam.epochs=2000;
% bp 网络训练
net=train(net,p,t);
%% 变量筛选 MIV 算法的差值计算
% 转置后 sim
for i=1:n
    eval(['p_increase',num2str(i),'=transpose(p_increase',num2str(i),');'])
end
for i=1:n
    eval(['p_decrease',num2str(i),'=transpose(p_decrease',num2str(i),');'])
end
% result_in 为增加 10%后的输出 result_de 为减少 10%后的输出
for i=1:n
    eval(['result_in',num2str(i),'=sim(net,','p_increase',num2str(i),');'])
end
for i=1:n
    eval(['result_de',num2str(i),'=sim(net,','p_decrease',num2str(i),');'])
end
for i=1:n
    eval(['result_in',num2str(i),'=transpose(result_in',num2str(i),');'])
end
for i=1:n
    eval(['result_de',num2str(i),'=transpose(result_de',num2str(i),');'])
end
for i=1:n
    IV= ['result_in',num2str(i), '-result_de',num2str(i)];
    eval(['MIV_',num2str(i) ,'=mean(',IV,')'])
end
sum1=0;
for i=1:n
    eval(['sum1=sum1+','MIV_',num2str(i),';'])
end
if sum1 ~= 0
    for i=1:n
        eval(['temp=MIV_',num2str(i) ,'/sum1;'])
        k=['MIV_',num2str(i) ,'的权重=',num2str(temp)];
        disp(k);
    end
else
    for i=1:n
        k=['MIV_',num2str(i) ,'的权重=0'];
        disp(k);
    end
end