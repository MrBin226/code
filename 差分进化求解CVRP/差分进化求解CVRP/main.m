%
%      @���ߣ�����
%      @΢�Ź��ںţ��Ż��㷨������
%��ֽ�����������Լ���ĳ���·������
clc;
clear all;
data=importdata('data.txt');
MAXCAR=8;
MAXLOAD=100;
MAXGEN=300;
NP=100;%��Ⱥ��ģ
vertexs=data(:,2:3);
h=pdist(vertexs);
dist=squareform(h);
dist=round(dist);
Demand=data(:,4);
[m,~]=size(data);
cusnum=m-1;
F=1;%�������� 
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
            %����Ӧ������
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
disp(['��',num2str(g),'��',',','���ųɱ�Ϊ:',num2str(trace(end))]);
end
%���·��
best_route=decode(chrom(minId,:));
[~,m]=size(best_route);
for i =1:m
    disp(['����·��',num2str(i),':']);
    fprintf('%c', 8);
    for j=1:length(best_route{i})-1
        disp([num2str(best_route{i}(j)),'->']);
        fprintf('%c', 8);
    end
    disp(num2str(best_route{i}(end)));
    
end

disp(['����ʹ�ó�����Ϊ:',num2str(m),',','�����ʻ����Ϊ:',num2str(trace(end)-m*1000)])
figure;
[r,c]=size(trace);
plot([1:c],trace(1,:));
title('��������');
draw(chrom(minId,:),data)