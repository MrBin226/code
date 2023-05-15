function pop=initPoP(popsize,destory_task_num,service_people,skill_num,destory_task_skill)
pop=cell(popsize,1);
for i=1:popsize
    seq=zeros(skill_num+1,destory_task_num);
    seq(1,:)=randperm(destory_task_num);
    for j=1:skill_num
        temp=zeros(1,destory_task_num);
        idx=find(destory_task_skill(:,j));
        a=service_people{j};
        for k=1:length(idx)
            temp(idx(k))=a(randperm(numel(a),1));
        end
        seq(j+1,:)=temp;
    end
    seq(2:end,:)=seq(2:end,seq(1,:));
    pop{i}=seq;
end

end

