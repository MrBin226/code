clc;
clear;
close all;

%% 模型数据
data=xlsread('数据.xlsx','A1:D1001');
vertexs=data(:,2:3); %所有点的坐标x和y
[IDX,C]=kmeans(vertexs,100,'Replicates',5,'Start','uniform');
% rgb=[204,0,255;...
%     220,20,60;...
%     106,90,205;...
%     0,0,255;...
%     0,191,255;...
%     0,255,255;...
%     0,250,154;...
%     255,255,0;...
%     128,128,0;...
%     255,165,0;...
%     139,69,19;...
%     255,69,0;...
%     165,42,42;...
%     0,0,0;...
%     0,255,0;...
%     250,250,210;...
%     255,0,0;...
%     128,128,128;...
%     	0,191,255;...
%         75,0,130];
%     rgb=rgb/255;
hold on
title('聚类效果图')
for i=1:100
    scatter(vertexs(IDX==i,1),vertexs(IDX==i,2),ones(size(vertexs(IDX==i,1)))*50,repmat(rand(1,3),length(find(IDX==i)),1),'filled')
end
for i=1:100
    scatter(C(i,1),C(i,2),50,'r^','filled');
end
demand=[];
order={};
for i=1:100
    fprintf('第%d类编号：',i);
    idx=find(IDX==i);
    demand=[demand sum(data(idx,4))];
    for j=1:length(idx)
        fprintf('%d ',idx(j))
    end
    fprintf('\n');
    s=[];
    for j=1:length(idx)
        if idx(j)==idx(end)
            s=[s,num2str(idx(j))];
        else
            s=[s,[num2str(idx(j)),',']];
        end
    end
    order{i,1}=s;
end
disp('聚类中心坐标：');
disp(C);
tab=table(C(:,1),C(:,2),demand',order,'VariableNames',{'x','y','demands','order'});
writetable(tab,'T.txt')











