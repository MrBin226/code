clc;
clear;
close all;

%% 相关参数设置
x1=0.01;%元件的长，单位m
y1=0.01;%元件的宽
l_d=0.002;%元件的厚度
x2=0.01;%元件之间在x方向上的宽度
y2=0.01;%元件之间在y方向上的宽度
row=2;%元件排列共两行
column=3;%每行有3个元件
count=row*column;%元件个数
S=[0.145,0.632,0.471,0.145,0.25,0.713];%各个元件的功率
lamda_c=0.8;%元件的导热系数
lamda_g=0.0261;%空气的传热系数
T=20;%环境温度为20
a_c=3;%元件与空气的导热系数
a_lamda=150;%PCB板与元件的导热系数

%% 算法迭代开始
sol_new=randperm(count);%每次产生的新解
sol_current=sol_new;%当前解
sol_best=sol_new;%最好的解
E_new=cal_max_temp(sol_new,x1,y1,l_d,x2,y2,lamda_c,lamda_g,a_c,a_lamda,S,row,column,T);
E_current=E_new;
E_best=E_new;
T0=20;%初始温度
Tf=0.05;%终止温度
T=T0;%当前温度
degrad=0.99;%冷却系数
Markov_length=600;%马尔可夫链的长度
min_fit=[];
while Tf<=T
    for i=1:Markov_length
        % 产生新的解（随机交换2个位置）
        idx=sort(randi(count,1,2));
        temp=sol_new(idx(1));
        sol_new(idx(1))=sol_new(idx(2));
        sol_new(idx(2))=temp;
        %计算新解的目标函数值
        E_new=cal_max_temp(sol_new,x1,y1,l_d,x2,y2,lamda_c,lamda_g,a_c,a_lamda,S,row,column,T);
        %退火操作
        if E_new < E_current
            E_current=E_new;
            sol_current=sol_new;
            if E_new < E_best
                E_best=E_new;
                sol_best=sol_new;
            end
        else
            % 若新解目标函数值大于当前解，则以一定概率接受
            if rand() < exp(-(E_new-E_current)/T)
                E_current=E_new;
                sol_current=sol_new;
            else
                % 不接受新解
                sol_new=sol_current;
            end
        end
    end
    T=degrad*T;
    min_fit=[min_fit E_best];
end
hold off
figure(1)
plot(1:length(min_fit),min_fit)
xlabel('迭代次数')
ylabel('最优适应度值')
disp('最优适应度值为：');
disp(E_best);
disp('最优布局为：');
layout=reshape(sol_best,column,row)';
disp(layout);



% 计算一组布局的最大温度
% function [max_temp]=cal_max_temp(sol,x1,y1,l_d,x2,y2,lamda_c,lamda_g,a_c,a_lamda,S,row,column,T)
% t=ones(row+2,column+2);
% t(1,:)=T;
% t(:,1)=T;
% t(row+2,:)=T;
% t(:,column+2)=T;
% e=1e-5;
% k=1;
% layout=reshape(sol,column,row)';
% lamda_h1=(lamda_c*lamda_g)/(2*lamda_g*x1+lamda_c*x2);
% lamda_h2=(lamda_c*lamda_g)/(2*lamda_g*y1+lamda_c*y2);
% c1=2*lamda_h1*y1*l_d/x1+2*lamda_h2*x1*l_d/y1+(a_c+a_lamda)*x1*y1;
% c2=1/c1;
% c3=(a_c*x1*y1*T+a_lamda*x1*y1*T)/c1;
% c4=(lamda_h1*y1*l_d/x1)/c1;
% c5=(lamda_h2*x1*l_d/y1)/c1;
% 
% while 1
%     tt=t;
%     for i=2:2+row-1
%         for j=2:2+column-1
%             t(i,j)=c3+c2*S(layout(i-1,j-1))+c4*t(i-1,j)+c4*t(i+1,j)+c5*t(i,j-1)+c5*t(i,j+1);
%         end
%     end
%     k=k+1;
%     ttt=abs(t(2,2)-tt(2,2));
%     if (ttt<e)
%         break
%     end
% end
% max_temp=max(max(t(2:2+row-1,2:2+column-1)));
% end



