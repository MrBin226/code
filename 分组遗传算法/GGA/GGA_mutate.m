function [mutated,mutatedbinno]=GGA_mutate(chromosome,chromindex,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk,BinNo,itemno)
mutated=cell(1);
mutatedbinno=0;
% mutno=floor(BinNo*mutratio);
f=zeros(BinNo,1);
for j=1:BinNo
    w_cpu=C_cpu-sum(R_cpu(chromosome{chromindex,j}));
    w_mem=C_mem-sum(R_mem(chromosome{chromindex,j}));
    w_disk=C_hardDisk-sum(R_hardDisk(chromosome{chromindex,j}));
    f(j)=w_cpu+w_mem+w_disk;
end
[~,idx]=sort(f);
% mutno=randi(floor(BinNo/2))+floor(BinNo/2)-1;
% start=randi(BinNo+1-mutno);
% while start==1
%     start=randi(BinNo+1-mutno);
% end
index=1;
for i=1:floor(BinNo/2)
    mutated{index}=chromosome{chromindex,idx(i)};
    index=index+1;
end
% for i=1:start-1
%     mutated{index}=chromosome{chromindex,i};
%     index=index+1;
% end
% for i=start+mutno:BinNo
%     mutated{index}=chromosome{chromindex,i};
%     index=index+1;
% end
index=index-1;

%% 计算未包含的元素
elements=[];
    for i=1:index
        elements=[elements,mutated{i}];
    end
    all=1:itemno;
    leftouts=~ismember(all,elements);
    leftouts=all(leftouts);
    ls=size(leftouts,2);
    %% 将未被包含的元素放入机器
    for i=1:ls
        notassigned=true;
        j=1;
        while(notassigned && j<=index)
            if(sum(R_cpu(mutated{j}))+R_cpu(leftouts(i))<=C_cpu && sum(R_mem(mutated{j}))+R_mem(leftouts(i))<=C_mem && sum(R_hardDisk(mutated{j}))+R_hardDisk(leftouts(i))<=C_hardDisk)
                mutated{j}=[mutated{j},leftouts(i)];
                notassigned=false;
            else
                j=j+1;
            end
        end
        if(notassigned)
            mutated{index+1}=leftouts(i);
            index=index+1;
        end
    end

mutatedbinno=index;
if length(unique(cell2mat(mutated))) < 250
    a=1;
end
end