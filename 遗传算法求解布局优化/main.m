clc;
clear;
close all;
nchr = 50;%��Ⱥ����
G = 200;%����ֹ��
pc = 0.8;%�������
pm = 0.1;%�������
%����ȫ�ֱ���,HΪ�����ܿ�LΪ�����ܳ���DeviceSizeΪ��������ߴ磬CijΪ������ã�QijΪ������
%deltaΪ�����������С���,TijΪ�໥��ϵ����BijΪ�������ӣ�TΪ�ͷ�ϵ��
global H L DeviceSize T Cij Qij delta Tij Bij;
H = 100;%�����
L = 180;%���䳤
DeviceSize = [36 18;36 18;36 18;36 18;36 18;36 18;...
    30 18;36 18;24 18;18 18;26 18;36 18;24 18];
Cij=1.5*ones(13);
Qij=xlsread('ʵ������.xlsx','E25:Q37');
Qij(isnan(Qij))=0;
Tij=xlsread('ʵ������.xlsx','E48:Q60');
delta=xlsread('ʵ������.xlsx','E7:Q19');
Bij=[0 46.67 1;...
    46.67 93.33 0.8;...
    93.33 140 0.6;...
	140 186.67 0.4;...
	186.67 233.33 0.2;...
	233.33 280 0];
T=10;

[chrx,MOC,PkG,LayoutG,best_X,best_Y] = GA(nchr,G,pc,pm);
best_Layout=LayoutG{end};
best_Layout(cellfun(@isempty,best_Layout))=[];
disp('���Ų������£�');
for i=1:length(best_Layout)
    line=best_Layout{i};
    fprintf('��%d�У�',i);
    for j=1:length(line)
        fprintf('����%d\t',line(j));
    end
    fprintf('\n');
end
figure(1)
plot(1:G,MOC);
xlabel('��������');
ylabel('����Ŀ�꺯��ֵ');
title('��������ͬĿ�꺯��ֵ����')
figure(2)
hold on
axis([0 L 0 H]);
for i=1:size(DeviceSize,1)
    rectangle('Position',[best_X(end,i)-DeviceSize(i,1)/2,best_Y(end,i)-DeviceSize(i,2)/2,DeviceSize(i,1),DeviceSize(i,2)]);
    text(best_X(end,i)-0.5,best_Y(end,i),num2str(i));
end
title('���Ų���ͼ');
xlabel('������');
ylabel('������');
hold off

