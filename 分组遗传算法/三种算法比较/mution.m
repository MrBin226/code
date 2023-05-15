function [new_children,mutionNo] = mution(children,offeringNo,mutratio,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk)
[m,n]=size(children);
new_children=zeros(m,n);
mutionNo=zeros(length(offeringNo),1);
for i=1:m
    if rand()<mutratio
        BinNo=offeringNo(i);
        mutno=randi(floor(BinNo/2))+floor(BinNo/2)-1;
        start=randi(BinNo+1-mutno);
        while start==1
            start=randi(BinNo+1-mutno);
        end
        index=1;
        for j=1:start-1
            new_children(i,children(i,:)==j)=index;
            index=index+1;
        end
        for j=start+mutno:BinNo
            new_children(i,children(i,:)==j)=index;
            index=index+1;
        end
        index=index-1;
        leftouts=find(new_children(i,:)==0);
        ls=size(leftouts,2);
        for k=1:ls
            notassigned=true;
            kk=1;
            while(notassigned && kk<=index)
                if(sum(R_cpu(new_children(i,:)==kk))+R_cpu(leftouts(k))<=C_cpu && sum(R_mem(new_children(i,:)==kk))+R_mem(leftouts(k))<=C_mem && sum(R_hardDisk(new_children(i,:)==kk))+R_hardDisk(leftouts(k))<=C_hardDisk)
                    new_children(i,leftouts(k))=kk;
                    notassigned=false;
                else
                    kk=kk+1;
                end
            end
            if(notassigned)
                new_children(i,leftouts(k))=index+1;
                index=index+1;
            end
        end
        mutionNo(i)=index;
    else
        new_children(i,:)=children(i,:);
        mutionNo(i)=offeringNo(i);
    end 
end
end

