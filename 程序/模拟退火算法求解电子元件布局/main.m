clc;
clear;
close all;

%% ��ز�������
x1=0.01;%Ԫ���ĳ�����λm
y1=0.01;%Ԫ���Ŀ�
l_d=0.002;%Ԫ���ĺ��
x2=0.01;%Ԫ��֮����x�����ϵĿ��
y2=0.01;%Ԫ��֮����y�����ϵĿ��
row=2;%Ԫ�����й�����
column=3;%ÿ����3��Ԫ��
count=row*column;%Ԫ������
S=[0.145,0.632,0.471,0.145,0.25,0.713];%����Ԫ���Ĺ���
lamda_c=0.8;%Ԫ���ĵ���ϵ��
lamda_g=0.0261;%�����Ĵ���ϵ��
T=20;%�����¶�Ϊ20
a_c=3;%Ԫ��������ĵ���ϵ��
a_lamda=150;%PCB����Ԫ���ĵ���ϵ��

%% �㷨������ʼ
sol_new=randperm(count);%ÿ�β������½�
sol_current=sol_new;%��ǰ��
sol_best=sol_new;%��õĽ�
E_new=cal_max_temp(sol_new,x1,y1,l_d,x2,y2,lamda_c,lamda_g,a_c,a_lamda,S,row,column,T);
E_current=E_new;
E_best=E_new;
T0=20;%��ʼ�¶�
Tf=0.05;%��ֹ�¶�
T=T0;%��ǰ�¶�
degrad=0.99;%��ȴϵ��
Markov_length=600;%����ɷ����ĳ���
min_fit=[];
while Tf<=T
    for i=1:Markov_length
        % �����µĽ⣨�������2��λ�ã�
        idx=sort(randi(count,1,2));
        temp=sol_new(idx(1));
        sol_new(idx(1))=sol_new(idx(2));
        sol_new(idx(2))=temp;
        %�����½��Ŀ�꺯��ֵ
        E_new=cal_max_temp(sol_new,x1,y1,l_d,x2,y2,lamda_c,lamda_g,a_c,a_lamda,S,row,column,T);
        %�˻����
        if E_new < E_current
            E_current=E_new;
            sol_current=sol_new;
            if E_new < E_best
                E_best=E_new;
                sol_best=sol_new;
            end
        else
            % ���½�Ŀ�꺯��ֵ���ڵ�ǰ�⣬����һ�����ʽ���
            if rand() < exp(-(E_new-E_current)/T)
                E_current=E_new;
                sol_current=sol_new;
            else
                % �������½�
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
xlabel('��������')
ylabel('������Ӧ��ֵ')
disp('������Ӧ��ֵΪ��');
disp(E_best);
disp('���Ų���Ϊ��');
layout=reshape(sol_best,column,row)';
disp(layout);



% ����һ�鲼�ֵ�����¶�
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



