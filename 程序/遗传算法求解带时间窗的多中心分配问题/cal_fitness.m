function fitness=cal_fitness(pop,task_skill,trans_time,adjacency,service_people_of_center,destory_task_index,control_center)
fitness=zeros(length(pop),1);
for i=1:length(pop)
    gen=pop{i};
    T=0;
    for j=1:size(gen,2)
        excute_time=[];
        pre_time=[];
        task_time=task_skill(gen(1,j),:);
        people=gen(2:end,j);
        if j==1
            for k=1:length(people)
                if people(k)
                    if k==1
                        time=trans_time;
                        time(setdiff(1:control_center,service_people_of_center(people(k))),:)=[];
                        time(:,setdiff(1:control_center,service_people_of_center(people(k))))=[];
                        t1=find_path(1,destory_task_index(gen(1,j),1)+1,tril(time));
                        t2=find_path(1,destory_task_index(gen(1,j),2)+1,tril(time));
                        t=min(t1,t2);
                        excute_time=[excute_time task_time(k)+t/60];
                        pre_time=[pre_time;[people(k) task_time(k)+t/60]];
                    else
                        if ~isempty(pre_time) && ismember(people(k),pre_time(:,1))
                            idx=find(pre_time(:,1)==people(k));
                            excute_time=[excute_time task_time(k)+pre_time(idx(end),2)];
                            pre_time=[pre_time;[people(k) task_time(k)+pre_time(idx(end),2)]];
                        else
                            time=trans_time;
                            time(setdiff(1:control_center,service_people_of_center(people(k))),:)=[];
                            time(:,setdiff(1:control_center,service_people_of_center(people(k))))=[];
                            t1=find_path(1,destory_task_index(gen(1,j),1)+1,tril(time));
                            t2=find_path(1,destory_task_index(gen(1,j),2)+1,tril(time));
                            t=min(t1,t2);
                            excute_time=[excute_time task_time(k)+t/60];
                            pre_time=[pre_time;[people(k) task_time(k)+t/60]];
                        end
                    end
                end
            end
        else
            for k=1:length(people)
                if people(k)
                    if k==1
                        if ismember(people(k),gen(2:end,j-1))
                            time=trans_time;
                            time(1:control_center,:)=[];
                            time(:,1:control_center)=[];
                            node=[destory_task_index(gen(1,j-1),1),destory_task_index(gen(1,j),1);...
                                  destory_task_index(gen(1,j-1),1),destory_task_index(gen(1,j),2);...
                                  destory_task_index(gen(1,j-1),2),destory_task_index(gen(1,j),1);...
                                  destory_task_index(gen(1,j-1),2),destory_task_index(gen(1,j),2)];
                            t=[];
                            for kk=1:4
                                t=[t find_path(node(kk,1),node(kk,2),tril(time))];
                            end
                            t=min(t);
                            excute_time=[excute_time task_time(k)+t/60];
                            pre_time=[pre_time;[people(k) task_time(k)+t/60]];
                        else
                            time=trans_time;
                            time(setdiff(1:control_center,service_people_of_center(people(k))),:)=[];
                            time(:,setdiff(1:control_center,service_people_of_center(people(k))))=[];
                            t1=find_path(1,destory_task_index(gen(1,j),1)+1,tril(time));
                            t2=find_path(1,destory_task_index(gen(1,j),2)+1,tril(time));
                            t=min(t1,t2);
                            excute_time=[excute_time task_time(k)+t/60];
                            pre_time=[pre_time;[people(k) task_time(k)+t/60]];
                        end
                    else
                        if ~isempty(pre_time) && ismember(people(k),pre_time(:,1))
                            idx=find(pre_time(:,1)==people(k));
                            excute_time=[excute_time task_time(k)+pre_time(idx(end),2)];
                            pre_time=[pre_time;[people(k) task_time(k)+pre_time(idx(end),2)]];
                        else
                            if ismember(people(k),gen(2:end,j-1))
                                time=trans_time;
                                time(1:control_center,:)=[];
                                time(:,1:control_center)=[];
                                node=[destory_task_index(gen(1,j-1),1),destory_task_index(gen(1,j),1);...
                                      destory_task_index(gen(1,j-1),1),destory_task_index(gen(1,j),2);...
                                      destory_task_index(gen(1,j-1),2),destory_task_index(gen(1,j),1);...
                                      destory_task_index(gen(1,j-1),2),destory_task_index(gen(1,j),2)];
                                t=[];
                                for kk=1:4
                                    t=[t find_path(node(kk,1),node(kk,2),tril(time))];
                                end
                                t=min(t);
%                                 t=find_path(destory_task_index(gen(1,j-1)),destory_task_index(gen(1,j)),tril(time));
                                excute_time=[excute_time task_time(k)+t/60];
                                pre_time=[pre_time;[people(k) task_time(k)+t/60]];
                            else
                                time=trans_time;
                                time(setdiff(1:control_center,service_people_of_center(people(k))),:)=[];
                                time(:,setdiff(1:control_center,service_people_of_center(people(k))))=[];
                                t1=find_path(1,destory_task_index(gen(1,j),1)+1,tril(time));
                                t2=find_path(1,destory_task_index(gen(1,j),2)+1,tril(time));
                                t=min(t1,t2);
%                                 t=find_path(1,destory_task_index(gen(1,j))+1,tril(time));
                                excute_time=[excute_time task_time(k)+t/60];
                                pre_time=[pre_time;[people(k) task_time(k)+t/60]];
                            end
                        end
                    end
                end
            end
        end
        T=T+max(excute_time);
    end
    fitness(i)=T;
end

end

