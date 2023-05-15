function [route] = get_route(first_node,end_node,f,l,c,a1,a2,gen,P,c_kt)
%得到两个节点的行驶路线
%   first_node:起始点
%   end_node:终点
%   f:需求
%   l:距离
%   c:运输费用
%   gen:枢纽节点
%   P:枢纽节点
route=[];
m_node=P(gen==1);
% || sum(ismember(m_node,first_node))==1 || sum(ismember(m_node,end_node))==1
if sum(gen) == 0
    route=[first_node end_node];
else
%     if sum(ismember(m_node,first_node))==1 || sum(ismember(m_node,end_node))==1
%         mm_node=m_node;
%         mm_node=setdiff(mm_node,[first_node end_node]);
%         if isempty(mm_node)
%            route=[first_node end_node];
%         else
%             nodes=[1,2:length(mm_node)+2];
%             b_e=nchoosek(nodes,2);
%             begin_end=[];
%             c_value=[];
%             flag=including(m_node,first_node,end_node);
%             for k=1:size(b_e,1)
%                 if b_e(k,1)==1
%                     begin_end=[begin_end;b_e(k,:)];
%                     if b_e(k,2)==(length(mm_node)+2)
%                         switch(flag)
%                             case 0
%                                 cost=a2*f(first_node,end_node)*l(first_node,end_node)*c(first_node,end_node);
%                             case 1
%                                 cost=f(first_node,end_node)*l(first_node,end_node)*c(first_node,end_node);
%                             case 2
%                                 cost=a1*f(first_node,end_node)*l(first_node,end_node)*c(first_node,end_node);
%                         end
%                     else
%                         if flag==1
%                             cost=f(first_node,end_node)*l(first_node,mm_node(b_e(k,2)-1))*c(first_node,mm_node(b_e(k,2)-1));
%                         else
%                             cost=a1*f(first_node,end_node)*l(first_node,mm_node(b_e(k,2)-1))*c(first_node,mm_node(b_e(k,2)-1));
%                         end
%                     end
%                     c_value=[c_value cost];
%                     continue
%                 end
%                 if b_e(k,2)==(length(mm_node)+2)
%                     begin_end=[begin_end;b_e(k,:)];
%                     if flag==0
%                         cost=a2*f(first_node,end_node)*l(mm_node(b_e(k,1)-1),end_node)*c(mm_node(b_e(k,1)-1),end_node)+c_kt(mm_node(b_e(k,1)-1))*f(first_node,end_node);
%                     else
%                         cost=a1*f(first_node,end_node)*l(mm_node(b_e(k,1)-1),end_node)*c(mm_node(b_e(k,1)-1),end_node)+c_kt(mm_node(b_e(k,1)-1))*f(first_node,end_node);
%                     end
%                     c_value=[c_value cost];
%                     continue
%                 end
%                 begin_end=[begin_end;b_e(k,:);[b_e(k,2),b_e(k,1)]];
%                 cost=a1*f(first_node,end_node)*l(mm_node(b_e(k,1)-1),mm_node(b_e(k,2)-1))*c(mm_node(b_e(k,1)-1),mm_node(b_e(k,2)-1))+c_kt(mm_node(b_e(k,1)-1))*f(first_node,end_node);
%                 c_value=[c_value cost cost];
%             end
%             g = digraph(begin_end(:,1),begin_end(:,2),c_value);
%             [path,~] = shortestpath(g,1,length(mm_node)+2);
%             route=[first_node,mm_node(path(2:end-1)-1),end_node];
%         end
%     else
        cost1=f(first_node,end_node)*l(first_node,end_node)*c(first_node,end_node);
        if length(m_node)==1
            cost2=f(first_node,end_node)*l(first_node,m_node(1))*c(first_node,m_node(1))+...
                a2*f(first_node,end_node)*l(m_node(1),end_node)*c(m_node(1),end_node)+c_kt(m_node(1))*f(first_node,end_node);
            if cost2 < cost1
                route=[first_node m_node end_node];
            else
                route=[first_node end_node];
            end
            %+c_k(m_node(1))+c_kt(m_node(1))
        else
            nodes=[1,2:length(m_node)+2];
            b_e=nchoosek(nodes,2);
            begin_end=[];
            c_value=[];
            for k=1:size(b_e,1)
                if b_e(k,1)==1
                    begin_end=[begin_end;b_e(k,:)];
                    if b_e(k,2)==(length(m_node)+2)
                        cost=cost1;
                    else
                        cost=f(first_node,end_node)*l(first_node,m_node(b_e(k,2)-1))*c(first_node,m_node(b_e(k,2)-1));
                    end
                    c_value=[c_value cost];
                    continue
                end
                if b_e(k,2)==(length(m_node)+2)
                    begin_end=[begin_end;b_e(k,:)];
                    cost=a2*f(first_node,end_node)*l(m_node(b_e(k,1)-1),end_node)*c(m_node(b_e(k,1)-1),end_node)+c_kt(m_node(b_e(k,1)-1))*f(first_node,end_node);
                    c_value=[c_value cost];
                    continue
                end
                begin_end=[begin_end;b_e(k,:);[b_e(k,2),b_e(k,1)]];
                cost=a1*f(first_node,end_node)*l(m_node(b_e(k,1)-1),m_node(b_e(k,2)-1))*c(m_node(b_e(k,1)-1),m_node(b_e(k,2)-1))+c_kt(m_node(b_e(k,1)-1))*f(first_node,end_node);
                c_value=[c_value cost cost];
            end
            g = digraph(begin_end(:,1),begin_end(:,2),c_value);
            [path,~] = shortestpath(g,1,length(m_node)+2);
            route=[first_node,m_node(path(2:end-1)-1),end_node];
        end
%     end
end
end

