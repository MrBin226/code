%
%      @作者：挽月
%      @微信公众号：优化算法交流地
%差分进化求解带容量约束的车辆路径问题
clc;
clear all;
data=importdata('data.txt');
MAXCAR=8;
MAXLOAD=100;
MAXGEN=300;
NP=100;%种群规模
vertexs=data(:,2:3);
h=pdist(vertexs);
dist=squareform(h);
dist=round(dist);
Demand=data(:,4);
[m,~]=size(data);
cusnum=m-1;
F=1;%缩放因子 
chrom=init(NP,cusnum,dist,Demand,MAXCAR,MAXLOAD);
chromx=chrom;
obj=calobj(chrom,dist,Demand,MAXLOAD);
for g=1:MAXGEN
    for i=1:NP
        v=mutate(chrom,i,F,MAXCAR,cusnum);
        x=chrom(i,:);
        vObj=calobj(v,dist,Demand,MAXLOAD);
        if vObj<obj(i)
            chrom(i,:)=v;
            obj(i)=vObj;
        else
            %自适应交叉率
           CR=0.3+g*0.6/MAXGEN;
           u=cross(v,x,dist,CR,Demand,MAXLOAD);
           uObj=calobj(u,dist,Demand,MAXLOAD);
           if uObj<obj(i) 
                chrom(i,:)=u;
                obj(i)=uObj;
           else
               len=ceil(cusnum/3);
               w=LargeSearch(chrom(i,:),len,cusnum,dist,Demand,MAXLOAD);
               wObj=calobj(w,dist,Demand,MAXLOAD);
               if wObj<obj(i)
                   chrom(i,:)=w;
                   wObj=obj(i);
               else
                   z=localSearch(chrom(i,:),cusnum,dist);
                   zObj=calobj(z,dist,Demand,MAXLOAD);
                   if zObj<obj(i)
                       chrom(i,:)=z;
                       zObj=obj(i);
                   end
               end
           end
        end
    end
[trace(g),minId]=min(obj);
disp(['第',num2str(g),'代',',','最优成本为:',num2str(trace(end))]);
end
%输出路径
best_route=decode(chrom(minId,:));
[~,m]=size(best_route);
for i =1:m
    disp(['配送路线',num2str(i),':']);
    fprintf('%c', 8);
    for j=1:length(best_route{i})-1
        disp([num2str(best_route{i}(j)),'->']);
        fprintf('%c', 8);
    end
    disp(num2str(best_route{i}(end)));
    
end

disp(['最少使用车辆数为:',num2str(m),',','最短行驶距离为:',num2str(trace(end)-m*1000)])
figure;
[r,c]=size(trace);
plot([1:c],trace(1,:));
title('进化过程');
draw(chrom(minId,:),data)