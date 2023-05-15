clc;
clear;
%load zx.txt %�������� %����ԭ���ĳ���
% �����Ҫ�������ݣ�ֻ��Ҫ���ĵ�5�е��ļ�·����39�е�21������21�����룬Ҳ��Ҫ�������
zx = xlsread('200����Ч�������A1~F3.xls');
jg=zx; %��������ѵ�� BP ������
%p=[jg(:,1),jg(:,2),jg(:,3),jg(:,4),jg(:,5),jg(:,6)];
p=jg;
% t=jg(:,7);
t=jg(:,end);
p=p';
t=t';
%% MIV ���ӻ��߼����Ա���
p=p';
[m,n]=size(p);
yy_temp=p;
% p_increase Ϊ���� 10%�ľ��� p_decrease Ϊ���� 10%�ľ���
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
%% ����ԭʼ����ѵ��һ����ȷ��������
nntwarn off;
p=yy_temp;
p=p';
% bp ���罨��
net=newff(minmax(p),[21,1],{'tansig','purelin'},'traingdm');
% ��ʼ�� bp ����
net=init(net);
% ����ѵ����������
net.trainParam.show=50;
net.trainParam.lr=0.05;
net.trainParam.mc=0.9;
net.trainParam.epochs=2000;
% bp ����ѵ��
net=train(net,p,t);
%% ����ɸѡ MIV �㷨�Ĳ�ֵ����
% ת�ú� sim
for i=1:n
    eval(['p_increase',num2str(i),'=transpose(p_increase',num2str(i),');'])
end
for i=1:n
    eval(['p_decrease',num2str(i),'=transpose(p_decrease',num2str(i),');'])
end
% result_in Ϊ���� 10%������ result_de Ϊ���� 10%������
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
        k=['MIV_',num2str(i) ,'��Ȩ��=',num2str(temp)];
        disp(k);
    end
else
    for i=1:n
        k=['MIV_',num2str(i) ,'��Ȩ��=0'];
        disp(k);
    end
end