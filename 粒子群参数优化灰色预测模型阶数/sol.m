function [gBest,gBestScore,cg_curve] = sol(data)
%% pso算法参数设置
N=10;%粒子数
c1=1;%学习因子
c2=2;
w_min=0.2;%惯性权重
w_max=0.9;
v_max=2*0.1;%速度最大值，与变量最大值相等
v_min=0.01;
lb=0.01;%变量下界，即阶数最小值
ub=2;
dim=1;%维度,只有一个参数
iter=100;%迭代次数

%% 初始化
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
%     fprintf('第%d次迭代，最优目标值为：%.2f\n',l,gBestScore)
end


end

