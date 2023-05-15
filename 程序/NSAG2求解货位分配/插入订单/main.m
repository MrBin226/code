clc;
clear;
close all;

%% ģ�Ͳ���
commodity_pos=importdata('position.txt');
out_order_data=importfile('pre_out_order_data.txt',',');%���ⶩ������
in_order_data=importfile('pre_in_order_data.txt',',');%��ⶩ������

% ���ò���Ϊȫ�ֱ���
global out_order_pos in_order_pos warehouse;

out_order_pos=commodity_pos([out_order_data{:}],:);%������Ʒ����
in_order_pos=commodity_pos([in_order_data{:}],:);%�����Ʒ����
%�����߶���
task_num=max(size(out_order_pos,1),size(in_order_pos,1));%��������
out_num=size(out_order_pos,1);
in_num=size(in_order_pos,1);
out_order_pos(size(out_order_pos,1)+1:task_num,:)=zeros(task_num-size(out_order_pos,1),3);
in_order_pos(size(in_order_pos,1)+1:task_num,:)=zeros(task_num-size(in_order_pos,1),3);
% ���òֿ����
warehouse.t_sf=1;
warehouse.t_sr=1.5;
warehouse.t_cf=1;
warehouse.t_cr=1.5;
warehouse.t_zf=1;
warehouse.t_zr=1.5;
warehouse.v_c=1.5;%���󳵵��ٶ�
warehouse.v_s=1.5;%���������ٶ�
warehouse.a_c=1;%���󳵵ļ��ٶ�
warehouse.a_s=1;%�������ļ��ٶ�
warehouse.l=1.5;%��λ����
warehouse.h=2;%���ܵĸ߶�

%% �㷨����
N = 100;       % ���Ǹ���
Max_iter = 200;  % ����������
lb = -task_num-50;   % Lower Bound
ub = task_num+50;   % Upper Bound
dim = task_num;   % ά��
fobj=@cal_fitness;%��Ӧ�Ⱥ���

%% ����GWO�㷨
[Best_score,Best_pos,GWO_cg_curve]=GWO(N,Max_iter,lb,ub,dim,fobj);
fid = fopen('result.txt','w');
fprintf(fid,'����Ŀ��ֵ��%.4f',Best_score);
[~,seq]=sort(Best_pos);
fprintf(fid,'��Խ������(%d���������->%d����������)��\n',in_num,out_num);
for i=1:length(seq)
    if seq(i)>out_num
        if i<=in_num
            fprintf(fid,'%d->%d\n',i,0);
        end
    else
        if i<=in_num
            fprintf(fid,'%d->%d\n',i,seq(i));
        else
            fprintf(fid,'%d->%d\n',0,seq(i));
        end
    end
end
fclose(fid);
figure(1);
hold on
plot(GWO_cg_curve,'Color','red','LineWidth',1.0);
title('��������ͼ');
xlabel('��������','FontWeight','bold','FontSize',11,'FontName','����');
ylabel('��Ӧ��ֵ','FontWeight','bold','FontSize',11,'FontName','����');













