function child_nodes = child_nodes_cal(parent_node, m, n, obs, closeList,status,target_node,start_node)

child_nodes = [];
field = [0,0; n-1,1; n-1,m-1; 0,m-1];
% 上

child_node = [parent_node(1), parent_node(2)+1];
if inpolygon(child_node(1), child_node(2), field(:,1), field(:,2))
    if ~ismember(child_node, obs, 'rows')
            child_nodes = [child_nodes; child_node];
    end
end

% 下
child_node = [parent_node(1), parent_node(2)-1];
if inpolygon(child_node(1), child_node(2), field(:,1), field(:,2))
    if ~ismember(child_node, obs, 'rows')
            child_nodes = [child_nodes; child_node];
    end
end

if status==0
    %左
    child_node = [parent_node(1)-1, parent_node(2)];
    if inpolygon(child_node(1), child_node(2), field(:,1), field(:,2))
        if ~ismember(child_node, obs, 'rows')
            child_nodes = [child_nodes; child_node];
        end
    end

    % 右
    child_node = [parent_node(1)+1, parent_node(2)];
    if inpolygon(child_node(1), child_node(2), field(:,1), field(:,2))
        if ~ismember(child_node, obs, 'rows')
                child_nodes = [child_nodes; child_node];
        end
    end

elseif status==1
    if ~ismember(parent_node, start_node, 'rows')
        %左
        child_node = [parent_node(1)-1, parent_node(2)];
        if inpolygon(child_node(1), child_node(2), field(:,1), field(:,2))
            if ~ismember(child_node, obs, 'rows')
                child_nodes = [child_nodes; child_node];
            end
        end

        % 右
        child_node = [parent_node(1)+1, parent_node(2)];
        if inpolygon(child_node(1), child_node(2), field(:,1), field(:,2))
            if ~ismember(child_node, obs, 'rows')
                    child_nodes = [child_nodes; child_node];
            end
        end
    end
elseif status==2
    %左
    child_node = [parent_node(1)-1, parent_node(2)];
    if inpolygon(child_node(1), child_node(2), field(:,1), field(:,2))
        if ~ismember(child_node, obs, 'rows')
            if ~ismember(child_node, target_node, 'rows')
                child_nodes = [child_nodes; child_node];
            end
        end
    end

    % 右
    child_node = [parent_node(1)+1, parent_node(2)];
    if inpolygon(child_node(1), child_node(2), field(:,1), field(:,2))
        if ~ismember(child_node, obs, 'rows')
             if ~ismember(child_node, target_node, 'rows')
                child_nodes = [child_nodes; child_node];
            end
        end
    end
end
%% 排除已经存在于closeList的节点
delete_idx = [];
for i = 1:size(child_nodes, 1)
    if ismember(child_nodes(i,:), closeList , 'rows')
        delete_idx(end+1,:) = i;
    end
end
child_nodes(delete_idx, :) = [];