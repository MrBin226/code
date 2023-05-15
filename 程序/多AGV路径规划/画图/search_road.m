function [path_opt,flag] = search_road(start_node,target_node,obs,m,n,status,collision)
if nargin<7
    collision=[];
end

flag=0;
% ��ʼ��closeList
closeList = start_node;
closeList_path = {start_node,start_node};
closeList_cost = 0;
child_nodes = child_nodes_cal(start_node,  m, n, obs, closeList,status,target_node,start_node); 

if isempty(child_nodes)
    flag=1;
    obs=setdiff(obs,collision,'rows');
    child_nodes = child_nodes_cal(start_node,  m, n, obs, closeList,status,target_node,start_node); 
end

% ��ʼ��openList
openList = child_nodes;
pre_node=[];
for i = 1:size(openList,1)
    openList_path{i,1} = openList(i,:);
    openList_path{i,2} = [start_node;openList(i,:)];
    pre_node=[pre_node;start_node];
end

for i = 1:size(openList, 1)
    g = norm(start_node - openList(i,1:2));
    h = abs(target_node(1) - openList(i,1)) + abs(target_node(2) - openList(i,2));
    f = g + h;
    openList_cost(i,:) = [g, h, f];
end

%% ��ʼ����
% ��openList��ʼ�����ƶ�������С�Ľڵ�
[~, min_idx] = min(openList_cost(:,3));
parent_node = openList(min_idx,:);
p_node=start_node;

%% ����ѭ��
flag = 1;
while flag   
    
    % �ҳ����ڵ�ĺ���closeList���ӽڵ�
    child_nodes = child_nodes_cal(parent_node,  m, n, obs, closeList,status,target_node,start_node); 
    
    
    % �ж���Щ�ӽڵ��Ƿ���openList�У����ڣ���Ƚϸ��£�û����׷�ӵ�openList��
    for i = 1:size(child_nodes,1)
        child_node = child_nodes(i,:);
        [in_flag,openList_idx] = ismember(child_node, openList, 'rows');
        g = openList_cost(min_idx, 1) + norm(parent_node - child_node);
        h = abs(child_node(1) - target_node(1)) + abs(child_node(2) - target_node(2));
        if all((parent_node - child_node)==(p_node - parent_node))
            r=0;
        else
            r=0.15;
        end
        f = g+h+r;
        
        if in_flag   % ���ڣ��Ƚϸ���g��f        
            if g < openList_cost(openList_idx,1)
                openList_cost(openList_idx, 1) = g;
                openList_cost(openList_idx, 3) = f;
                openList_path{openList_idx,2} = [openList_path{min_idx,2}; child_node];
            end
        else         % �����ڣ�׷�ӵ�openList
            openList(end+1,:) = child_node;
            pre_node(end+1,:) = parent_node;
            openList_cost(end+1, :) = [g, h, f];
            openList_path{end+1, 1} = child_node;
            openList_path{end, 2} = [openList_path{min_idx,2}; child_node];
        end
    end
   
    
    % ��openList�Ƴ��ƶ�������С�Ľڵ㵽 closeList
    closeList(end+1,: ) =  openList(min_idx,:);
    closeList_cost(end+1,1) =   openList_cost(min_idx,3);
    closeList_path(end+1,:) = openList_path(min_idx,:);
    openList(min_idx,:) = [];
    pre_node(min_idx,:) = [];
    openList_cost(min_idx,:) = [];
    openList_path(min_idx,:) = [];
 
    % ������������openList�����ƶ�������С�Ľڵ�
    [~, min_idx] = min(openList_cost(:,3));
    parent_node = openList(min_idx,:);
    p_node=pre_node(min_idx,:);
    % �ж��Ƿ��������յ�
    if parent_node == target_node
        closeList(end+1,: ) =  openList(min_idx,:);
        closeList_cost(end+1,1) =   openList_cost(min_idx,1);
        closeList_path(end+1,:) = openList_path(min_idx,:);
        flag = 0;
    end

end
path_opt = closeList_path{end,2};


end

