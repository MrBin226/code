function [solution] = decode(chromsome,distance,demand,A,ub,lb)
select_place=find(chromsome(1,:)==1);
bulild_class=chromsome(2,select_place);
solution.deliver_plan=cell(size(demand,1),1);
solution.storage_num=zeros(size(distance,1),1);
distribute_count=arrayfun(@(x) ub(bulild_class(x)),1:length(select_place));
for i=1:size(demand,1)
    demand_place=find(demand(i,:)>0);
    rr=[];
    for k=1:length(demand_place)
        rr=[rr find(A(:,demand_place(k))==1)];
    end
    rr=unique(rr);
    u_s = intersect(rr,select_place);
    node_num=length(u_s)+length(demand_place)+3;
    a=zeros(node_num);
    c=zeros(node_num);
    for r=1:node_num
        if r==1
            for k=2:length(u_s)+1
                c(1,k)=distribute_count(select_place==u_s(k-1));
                a(1,k)=100;
            end
        end
        if (1+length(u_s)+1)==r
            for k=1:length(demand_place)
                c(k+1+length(u_s),2+length(u_s)+length(demand_place))=demand(i,demand_place(k));
                a(k+1+length(u_s),2+length(u_s)+length(demand_place))=100;
                u = intersect(find(A(:,demand_place(k))==1),select_place);
                for tt=1:length(u)
                    c(find(u_s==u(tt))+1,k+1+length(u_s))=c(1,find(u_s==u(tt))+1);
                    a(find(u_s==u(tt))+1,k+1+length(u_s))=distance(u(tt),demand_place(k))*1000;
                end
            end
        end  
    end
    c(node_num-1,node_num)=sum(demand(i,:));
    a(node_num-1,node_num)=100;
    M=sum(sum(c))*node_num^2;
%     [flow,~]=mincostmaxflow(c,a,M,node_num);
    flow=BGf(c,a);
    ps=find(flow(1,:)>0);
    temp=[];
    for j=1:length(ps)
        pd=find(flow(ps(j),:)>0);
        for k=1:length(pd)
            temp=[temp;[u_s(ps(j)-1) demand_place(pd(k)-length(u_s)-1) flow(ps(j),pd(k))]];
        end
        solution.storage_num(u_s(ps(j)-1))=max([sum(flow(ps(j),pd)),solution.storage_num(u_s(ps(j)-1))]);
    end
    solution.deliver_plan{i}=temp;
end
save_num=solution.storage_num(solution.storage_num>0);
save_index=find(solution.storage_num>0);
idx=arrayfun(@(x) find(select_place==save_index(x)),1:length(save_index));
least_count=arrayfun(@(x) lb(bulild_class(x)),1:length(select_place));
least_count=least_count(idx);
least_count=least_count';
save_num(save_num<least_count)=least_count(save_num<least_count);
solution.storage_num(save_index)=save_num;
end

