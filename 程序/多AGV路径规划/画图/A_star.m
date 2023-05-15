clc
clear
close all

% 栅格地图的行数、列数定义
m = 22;
n = 45;
shelve = importdata('货架坐标.txt');
pick_table=importdata('拣选台坐标.txt');
agv=[0,20,45,2];
charg_pile=[1,0,1,1;8,0,1,1;15,0,1,1;22,0,1,1;29,0,1,1;36,0,1,1;43,0,1,1];
AGV_num=20;
pick_table_num=10;
AGV_start_pos=[floor(linspace(1,n-1,AGV_num))',repmat(m-2,AGV_num,1)];
AGV_stop_pos=AGV_start_pos;
shelve_pos=trans_coordinate(shelve);
pick_table_pos=trans_coordinate(pick_table);
agv_pos=trans_coordinate(agv);
charg_pile_pos=trans_coordinate(charg_pile);
task=importdata('任务文件.txt');% 前两列是货架坐标，第3列是去第几个拣选台，第4列是第几个AGV执行，第5列是AGV执行该任务的初始时刻
task(all(task==0,2),:)=[];
status=zeros(AGV_num,1);%初始各个AGV都是空载
obs=arrayfun(@(x) [pick_table_pos;agv_pos;charg_pile_pos],1:AGV_num,'UniformOutput',0);
dynamic_path=[];

time=0;
dynamic_agv_pos=AGV_start_pos;


figure('Position',[200 200 1400 700], 'MenuBar','none');
axes('position', [0 0 1 0.97]);
cmap1=rand(AGV_num,3);
plotAll(m,n,shelve,pick_table,agv,charg_pile);
for i=1:size(AGV_start_pos,1)
    rectangle('Position',[AGV_start_pos(i,1)+0.1,AGV_start_pos(i,2)+0.1,0.8,0.8],'FaceColor','white')
    rectangle('Position',[AGV_start_pos(i,1)+0.25,AGV_start_pos(i,2)+0.25,0.5,0.5], 'FaceColor',cmap1(i,:))
    text(AGV_start_pos(i,1)+0.35,AGV_start_pos(i,2)+0.52,num2str(i));
end

free_status=zeros(AGV_num,1);

%% 系统路径规划开始
    ta=task(task(:,5)==time,1:4);
    ta=sortrows(ta,4);
    for i=1:size(ta,1)
        if free_status(ta(i,4),1)>time
            task(all(task(:,1:4)==ta(i,:),2),5)=free_status(ta(i,4),1);
            continue
        end
       %%  出发到货架
        start_node=AGV_start_pos(ta(i,4),:);
        target_node=ta(i,1:2);
        if status(ta(i,4))==0
            temp_obs=obs{ta(i,4)};
        else
            temp_obs=[obs{ta(i,4)};shelve_pos];
        end
        temp_obs=setdiff(temp_obs,[start_node;target_node],'rows');
        if isempty(dynamic_path)
            dynamic_path=[0,0,0,0,0;0 0 0 0 0];
        end
        [path_opt] = search_road(start_node,target_node,temp_obs,m,n,0);
        path_opt=[path_opt,(1:size(path_opt,1))'+time-1];
        collision=intersect(path_opt(2:end-1,:),dynamic_path(:,1:3),'rows','stable');
        collision1=intersect(cal_middle(path_opt(2:end-1,:)),cal_middle(dynamic_path(:,1:3)),'rows','stable');
        collision1(:,3)=path_opt(ismember(path_opt(:,1:2),floor(collision1(:,1:2)),'rows'),3);
        collision=[collision;floor(collision1)];
        count=1;
        while ~isempty(collision)
            temp_obs=[temp_obs;collision(:,1:2)];
            [path_opt,flag] = search_road(start_node,target_node,temp_obs,m,n,0,collision(:,1:2));
            if flag
                count=10;
            end
            path_opt=[path_opt,(1:size(path_opt,1))'+time-1];
            collision=intersect(path_opt(2:end-1,:),dynamic_path(:,1:3),'rows','stable');
            collision1=intersect(cal_middle(path_opt(2:end-1,:)),cal_middle(dynamic_path(:,1:3)),'rows','stable');
            collision1(:,3)=path_opt(ismember(path_opt(:,1:2),floor(collision1(:,1:2)),'rows'),3);
            collision=[collision;floor(collision1)];
            if count>=10
                while ~isempty(collision)
%                     path_opt=[path_opt,(1:size(path_opt,1))'+time-1];
                    idx=find(ismember(path_opt,collision,'rows')==1);
                    if isempty(idx)
                        tm=floor(collision1);
                        idx=find(ismember(path_opt,tm,'rows')==1);
                    end
                    path_opt(idx(1):end,3)=path_opt(idx(1):end,3)+1;
                    wait_time=wait_time+1;
                    collision=intersect(path_opt(2:end-1,:),dynamic_path(:,1:3),'rows','stable');
                    collision1=intersect(cal_middle(path_opt(2:end-1,:)),cal_middle(dynamic_path(:,1:3)),'rows','stable');
                    collision1(:,3)=path_opt(ismember(path_opt(:,1:2),floor(collision1(:,1:2)),'rows'),3);
                    collision=[collision;floor(collision1)];
                end
            end
            count=count+1;
        end
        dynamic_path=[dynamic_path;[path_opt,repmat(ta(i,4),size(path_opt,1),1),zeros(size(path_opt,1),1)]];
        status(ta(i,4))=1;
        AGV_start_pos(ta(i,4),:)=target_node;
        t=path_opt(end,3);
        %%  货架到拣选台,在货架停留1秒
        start_node=AGV_start_pos(ta(i,4),:);
        target_node=pick_table_pos(ta(i,3),:);
        if status(ta(i,4))==0
            temp_obs=obs{ta(i,4)};
        else
            temp_obs=[obs{ta(i,4)};shelve_pos];
        end
        temp_obs=setdiff(temp_obs,[start_node;target_node],'rows');
        [path_opt] = search_road(start_node,target_node,temp_obs,m,n,1);
        path_opt=[path_opt,(1:size(path_opt,1))'+t];
        collision=intersect(path_opt(2:end-1,:),dynamic_path(dynamic_path(:,3)>=t,1:3),'rows','stable');
        collision1=intersect(cal_middle(path_opt(2:end-1,:)),cal_middle(dynamic_path(dynamic_path(:,3)>=t,1:3)),'rows','stable');
        collision1(:,3)=path_opt(ismember(path_opt(:,1:2),floor(collision1(:,1:2)),'rows'),3);
        collision=[collision;floor(collision1)];
        count=1;
        while ~isempty(collision)
            temp_obs=[temp_obs;collision(:,1:2)];
            [path_opt,flag] = search_road(start_node,target_node,temp_obs,m,n,1,collision(:,1:2));
            if flag
                count=10;
            end
            path_opt=[path_opt,(1:size(path_opt,1))'+t];
            collision=intersect(path_opt(2:end-1,:),dynamic_path(dynamic_path(:,3)>=t,1:3),'rows','stable');
            collision1=intersect(cal_middle(path_opt(2:end-1,:)),cal_middle(dynamic_path(dynamic_path(:,3)>=t,1:3)),'rows','stable');
            collision1(:,3)=path_opt(ismember(path_opt(:,1:2),floor(collision1(:,1:2)),'rows'),3);
            collision=[collision;floor(collision1)];
            if count>=10
                while ~isempty(collision)
%                     path_opt=[path_opt,(1:size(path_opt,1))'+t];
                    idx=find(ismember(path_opt,dynamic_path(dynamic_path(:,3)>=t,1:3),'rows')==1);
                    if isempty(idx)
                        tm=floor(collision1);
                        idx=find(ismember(path_opt,tm,'rows')==1);
                    end
                    path_opt(idx(1):end,3)=path_opt(idx(1):end,3)+1;
                    wait_time=wait_time+1;
                    collision=intersect(path_opt(2:end-1,:),dynamic_path(dynamic_path(:,3)>=t,1:3),'rows','stable');
                    collision1=intersect(cal_middle(path_opt(2:end-1,:)),cal_middle(dynamic_path(dynamic_path(:,3)>=t,1:3)),'rows','stable');
                    collision1(:,3)=path_opt(ismember(path_opt(:,1:2),floor(collision1(:,1:2)),'rows'),3);
                    collision=[collision;floor(collision1)];
                end
            end
            count=count+1;
        end
        dynamic_path=[dynamic_path;[path_opt,repmat(ta(i,4),size(path_opt,1),1),ones(size(path_opt,1),1)]];
        status(ta(i,4))=1;
        AGV_start_pos(ta(i,4),:)=target_node;
        t=path_opt(end,3);
       %%  拣选台到货架,在拣选台停留1秒
        start_node=AGV_start_pos(ta(i,4),:);
        target_node=ta(i,1:2);
        if status(ta(i,4))==0
            temp_obs=obs{ta(i,4)};
        else
            temp_obs=[obs{ta(i,4)};shelve_pos];
        end
        temp_obs=setdiff(temp_obs,[start_node;target_node],'rows');
        [path_opt] = search_road(start_node,target_node,temp_obs,m,n,2);
        path_opt=[path_opt,(1:size(path_opt,1))'+t];
        collision=intersect(path_opt(2:end-1,:),dynamic_path(dynamic_path(:,3)>=t,1:3),'rows','stable');
        collision1=intersect(cal_middle(path_opt(2:end-1,:)),cal_middle(dynamic_path(dynamic_path(:,3)>=t,1:3)),'rows','stable');
        collision1(:,3)=path_opt(ismember(path_opt(:,1:2),floor(collision1(:,1:2)),'rows'),3);
        collision=[collision;floor(collision1)];
        count=1;
        while ~isempty(collision)
            temp_obs=[temp_obs;collision(:,1:2)];
            [path_opt,flag] = search_road(start_node,target_node,temp_obs,m,n,2,collision(:,1:2));
            if flag
                count=10;
            end
            path_opt=[path_opt,(1:size(path_opt,1))'+t];
            collision=intersect(path_opt(2:end-1,:),dynamic_path(dynamic_path(:,3)>=t,1:3),'rows','stable');
            collision1=intersect(cal_middle(path_opt(2:end-1,:)),cal_middle(dynamic_path(dynamic_path(:,3)>=t,1:3)),'rows','stable');
            collision1(:,3)=path_opt(ismember(path_opt(:,1:2),floor(collision1(:,1:2)),'rows'),3);
            collision=[collision;floor(collision1)];
            if count>=10
                while ~isempty(collision)
%                     path_opt=[path_opt,(1:size(path_opt,1))'+t];
                    idx=find(ismember(path_opt,dynamic_path(dynamic_path(:,3)>=t,1:3),'rows')==1);
                    if isempty(idx)
                        tm=floor(collision1);
                        idx=find(ismember(path_opt,tm,'rows')==1);
                    end
                    path_opt(idx(1):end,3)=path_opt(idx(1):end,3)+1;
                    wait_time=wait_time+1;
                    collision=intersect(path_opt(2:end-1,:),dynamic_path(dynamic_path(:,3)>=t,1:3),'rows','stable');
                    collision1=intersect(cal_middle(path_opt(2:end-1,:)),cal_middle(dynamic_path(dynamic_path(:,3)>=t,1:3)),'rows','stable');
                    collision1(:,3)=path_opt(ismember(path_opt(:,1:2),floor(collision1(:,1:2)),'rows'),3);
                    collision=[collision;floor(collision1)];
                end
            end
            count=count+1;
        end
        dynamic_path=[dynamic_path;[path_opt,repmat(ta(i,4),size(path_opt,1),1),ones(size(path_opt,1),1)]];
        status(ta(i,4))=0;
        AGV_start_pos(ta(i,4),:)=target_node;
        t=path_opt(end,3);
        free_status(ta(i,4),1)=t+1;
        
    end
    
    
%     time=time+1;
    
    cla;
    plotAll(m,n,shelve,pick_table,agv,charg_pile);
    for j=1:AGV_num
        rectangle('Position',[AGV_stop_pos(j,1)+0.1,AGV_stop_pos(j,2)+0.1,0.8,0.8],'FaceColor','white')
        temp=dynamic_path(dynamic_path(:,3)==time & dynamic_path(:,4)==j, 1:5);
        if ~isempty(temp)
            dynamic_agv_pos(j,:)=temp(1:2);
            if temp(5)==1
                rectangle('Position',[dynamic_agv_pos(j,1)+0.25,dynamic_agv_pos(j,2)+0.25,0.5,0.5], 'FaceColor',cmap1(j,:));
            else
                rectangle('Position',[dynamic_agv_pos(j,1)+0.25,dynamic_agv_pos(j,2)+0.25,0.5,0.5], 'FaceColor',cmap1(j,:));
            end
        else
            rectangle('Position',[dynamic_agv_pos(j,1)+0.25,dynamic_agv_pos(j,2)+0.25,0.5,0.5], 'FaceColor',cmap1(j,:));
        end
        
        text(dynamic_agv_pos(j,1)+0.35,dynamic_agv_pos(j,2)+0.52,num2str(j));
    end
    a=[5,13];
    for k=1:2
        path=dynamic_path(dynamic_path(:,4)==a(k), 1:2);
        path=path+0.5;
        plot(path(:,1),path(:,2),'Color',cmap1(a(k),:),'LineWidth',2);
        scatter(path(2:end,1),path(2:end,2),50,cmap1(a(k),:),'filled');
    end
    for j=1:AGV_num
        
        text(dynamic_agv_pos(j,1)+0.35,dynamic_agv_pos(j,2)+0.52,num2str(j));
    end
    
    
    
    
    
