function [fitness]=cal_fitness(pop,distance,demand,A,ub,lb,C,S,L,pur,stro,h,c,P_s,theta,rho,p)
fitness=zeros(length(pop),1);
for i=1:length(pop)
    chromsome=pop{i};
    [solution] = decode(chromsome,distance,demand,A,ub,lb);
    select_place=find(chromsome(1,:)==1);
    bulild_class=chromsome(2,select_place);
    f1=zeros(size(demand,2),1);
    for k=1:size(demand,2)
        s=find(demand(:,k)>0);
        plan=solution.deliver_plan(s);
        for j=1:length(plan)
            serivce_place=plan{j}(:,1);
            serivce_class=chromsome(2,serivce_place);
            cover_c=cell2mat(cellfun(@(c)c(:,k),theta,'UniformOutput',false));
            [~,cover_class]=find(cover_c(serivce_place,:)==1);
            cover_p=arrayfun(@(x) p(cover_class(x),serivce_class(x)),1:length(serivce_place));
            f1(k)=sum(P_s*rho(cover_class).*cover_p)+f1(k);
        end
    end
    f2=0;
    for k=1:S
        plan=solution.deliver_plan{k};
        if isempty(plan)
            continue
        end
        serivce_place=plan(:,1);
        demand_place=plan(1,2);
        serivce_class=chromsome(2,serivce_place);
        save_num=solution.storage_num(serivce_place);
        distribute_count=plan(:,3);
        f2=f2+P_s*(sum(c(serivce_class))+sum((pur+stro)*save_num)+h*sum(distance(serivce_place,demand_place).*distribute_count));
    end
    fitness(i)=(f2/100000)/(min(f1(f1>0))*10^7);
end


end

