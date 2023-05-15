clc;
clear all;
close all;

%% ģ�Ͳ�������
pick_coord=importdata('��ѡ̨����.txt');%��ȡ��ѡ̨����
pick_num=size(pick_coord,1);%��ѡ̨����
cargo_coord=importdata('��������.txt');%��ȡ�ֿ��ڸ�����������
cargo_coord=cargo_coord.data;
order_data=importfile('������Ϣ.txt','|');%��ȡ���������Ϣ
order=arrayfun(@(x) order_data(x).order,1:length(order_data),'UniformOutput',0)';%�õ���������
order_cargo_num=arrayfun(@(x) order_data(x).count,1:length(order_data),'UniformOutput',0)';%�õ���������
shelve_info=get_shelve_info('������Ʒ��Ϣ.txt',',');%��ȡ�ֿ��ڸ������ܴ�ŵ���Ʒ
q=35;%��ѡ̨�������
%��������ȫ������ȫ���ϲ����������
temp_cargo=cell2mat(order');
temp_num=cell2mat(order_cargo_num');
cargo=unique(temp_cargo);%������ȫ������
cargo_num=arrayfun(@(x) sum(temp_num(temp_cargo==cargo(x))),1:length(cargo));%��Ӧ�Ļ�������
v=1;%AGV���ٶ�
Tb=10;

%% �㷨��������
SearchAgents_no=10;%���Ǹ���
dim=length(cargo);%ά��
lb=1;%�½�
ub=pick_num+0.99;%�Ͻ�
Max_iter=100;%����������
Alpha_pos=zeros(1,dim);
Alpha_score=inf;
Beta_pos=zeros(1,dim);
Beta_score=inf; 
Delta_pos=zeros(1,dim);
Delta_score=inf;
Convergence_curve=zeros(1,Max_iter);
a_ini=2;
a_fin=0;

%% ��ʼ��
Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
% �Խ�λ�ý��е�����֤ÿ����ѡ̨�����з���

l=0;% ѭ������

%% ��ʼѭ��
while l<Max_iter
    for i=1:size(Positions,1)  
        
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;   
        Positions(i,:) = adjust(Positions(i,:),pick_num,cargo,cargo_num,q,cargo_coord,pick_coord);
        
        fitness=cal_obj(Positions(i,:),cargo_coord,cargo,pick_num,pick_coord,v,order,cargo_num,q,Tb);
        
        if fitness<Alpha_score 
            Alpha_score=fitness;
            Alpha_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness<Beta_score 
            Beta_score=fitness; 
            Beta_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score 
            Delta_score=fitness;
            Delta_pos=Positions(i,:);
        end
    end
    
    
    a=a_ini-(a_ini-a_fin)*(l/Max_iter)^2;
    
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)     
                       
            r1=rand(); 
            r2=rand();
            
            A1=2*a*r1-a; 
            C1=2*r2;
            
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j));
            X1=Alpha_pos(j)-A1*D_alpha; 
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; 
            C2=2*r2; 
            
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); 
            X2=Beta_pos(j)-A2*D_beta;     
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a;
            C3=2*r2;
            
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); 
            X3=Delta_pos(j)-A3*D_delta;             
            
            Positions(i,j)=(X1+X2+X3)/3;
            
        end
    end
    l=l+1;    
    Convergence_curve(l)=Alpha_score;
    fprintf('��%d�ε���������Ŀ��ֵΪ��%d\n',l,Alpha_score);
end

[fitness,dis,time,pick_to_cargos] = cal_obj(Alpha_pos,cargo_coord,cargo,pick_num,pick_coord,v,order,cargo_num,q,Tb);
fprintf('����Ŀ�꺯��ֵ��%d������ʱ��Ϊ��%ds����װʱ��Ϊ��%ds',fitness,sum(dis)/v,time);
all_num=0;
for i=1:pick_num
    for k=1:length(pick_to_cargos{i})
        for kk=1:length(shelve_info)
            if ~isempty(find(shelve_info{kk}==pick_to_cargos{i}(k)))
                shelve(k)=kk;
                break
            end
        end
    end
    all_num=all_num+length(unique(shelve));
end
fprintf(',�ܵİ��˴���Ϊ��%d\n',all_num);
for i=1:pick_num
    fprintf('��%d����ѡ̨�������ѡ�Ļ����ѡ̨%d->',i,i);
    for k=1:length(pick_to_cargos{i})
        fprintf('����%d->',pick_to_cargos{i}(k));
    end
    fprintf('��ѡ̨%d,���˾���Ϊ��%d,���˴���Ϊ��%d\n',i,dis(i),length(unique(shelve)));
end

figure(1)
plot(Convergence_curve);
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
title('GWO��������')





