function [gBest,gBestScore,cg_curve] = sol(data)
%% pso�㷨��������
N=10;%������
c1=1;%ѧϰ����
c2=2;
w_min=0.2;%����Ȩ��
w_max=0.9;
v_max=2*0.1;%�ٶ����ֵ����������ֵ���
v_min=0.01;
lb=0.01;%�����½磬��������Сֵ
ub=2;
dim=1;%ά��,ֻ��һ������
iter=100;%��������

%% ��ʼ��
pos = roundn(rand(N,dim).*(ub-lb)+lb,-2);
pBestScore=zeros(N,1);
pBest=zeros(N,dim);
gBest=zeros(1,dim);
cg_curve=zeros(1,iter);
vel=zeros(N,dim);
gBestScore=inf;
for i=1:N
    pBestScore(i)=inf;
end

for l=1:iter 
    

    for i=1:size(pos,1) 
         Flag4ub=pos(i,:)>ub;
         Flag4lb=pos(i,:)<lb;
         pos(i,:)=(pos(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        fitness=GM(data, pos(i,:));

        if(pBestScore(i)>fitness)
            pBestScore(i)=fitness;
            pBest(i,:)=pos(i,:);
        end
        if(gBestScore>fitness)
            gBestScore=fitness;
            gBest=pos(i,:);
        end
    end

    w=w_max-l*((w_max-w_min)/iter);
    for i=1:size(pos,1)
        for j=1:size(pos,2)       
            vel(i,j)=w*vel(i,j)+c1*rand()*(pBest(i,j)-pos(i,j))+c2*rand()*(gBest(j)-pos(i,j));
            
            if(vel(i,j)>v_max)
                vel(i,j)=v_max;
            end
            if(vel(i,j)<v_min)
                vel(i,j)=v_min;
            end            
            pos(i,j)=roundn(pos(i,j)+vel(i,j),-2);
        end
    end
    cg_curve(l)=gBest;
%     fprintf('��%d�ε���������Ŀ��ֵΪ��%.2f\n',l,gBestScore)
end


end

