function [new_pos,BinNo]=correct(pos,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk)
N = length(pos);
new_pos=zeros(1,N);
BinNo=0;
temp=unique(sort(pos));
injection=[];
for i=1:length(temp)
    vm=find(pos==temp(i));
    item_cpu=R_cpu(vm);
    item_mem=R_mem(vm);
    item_disk=R_hardDisk(vm);
    summ1=item_cpu(1);
    summ2=item_mem(1);
    summ3=item_disk(1);
    new_pos(vm(1))=i;
    for j=2:length(vm)
        if summ1+item_cpu(j)<=C_cpu && summ2+item_mem(j)<=C_mem && summ3+item_disk(j)<=C_hardDisk
            new_pos(vm(j))=i;
            summ1=summ1+item_cpu(j);
            summ2=summ2+item_mem(j);
            summ3=summ3+item_disk(j);
        else
            injection=[injection,vm(j)];
        end
    end 
end
index=length(temp);
for k=1:length(injection)
    notassigned=true;
    kk=1;
    while(notassigned && kk<=index)
        if(sum(R_cpu(new_pos==kk))+R_cpu(injection(k))<=C_cpu && sum(R_mem(new_pos==kk))+R_mem(injection(k))<=C_mem && sum(R_hardDisk(new_pos==kk))+R_hardDisk(injection(k))<=C_hardDisk)
            new_pos(injection(k))=kk;
            notassigned=false;
        else
            kk=kk+1;
        end
    end
    if(notassigned)
        new_pos(injection(k))=index+1;
        index=index+1;
    end
end
BinNo=length(unique(pos));
end

