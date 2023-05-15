function [children,OffBinNo] = crossover(parents,parentsBinNo,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk)
[row,column]=size(parents);
children=zeros(row,column);
OffBinNo=zeros(row,1);
offersize=floor(row/2);
for ii=1:offersize
    parent1=parents(ii*2-1,:);
    parent2=parents(ii*2,:);
    %% 产生交叉位置
    crossSite1=randi(parentsBinNo(ii*2-1)+1);
    crossSite2=randi(parentsBinNo(ii*2-1)-crossSite1+2)+crossSite1-1;

    crossSite3=randi(parentsBinNo(ii*2)+1);
    crossSite4=randi(parentsBinNo(ii*2)-crossSite3+2)+crossSite3-1;

    injection1=[];
    injection2=[];
    for i=crossSite1:crossSite2-1
        injection1=[injection1,find(parent1==i)];
    end
    for i=crossSite3:crossSite4-1
        injection2=[injection2,find(parent2==i)];
    end
    % 生成第一个子代
    index=1;
    child1=zeros(1,column);
    child2=zeros(1,column);
    for i=1:crossSite2-1
        if(~sum(ismember(find(parent1==i),injection2)))
            child1(parent1==i)=index;
            index=index+1;
        end
    end      
    for i=crossSite3:crossSite4-1
        child1(parent2==i)=index;
        index=index+1;
    end
    for i=crossSite2:parentsBinNo(ii*2-1)
        if(~sum(ismember(find(parent1==i),injection2)))
            child1(parent1==i)=index;
            index=index+1;
        end
    end
    index2=1;
    for i=1:crossSite3-1
        if(~sum(ismember(find(parent2==i),injection1)))
            child2(parent2==i)=index2;
            index2=index2+1;
        end
    end      
    for i=crossSite1:crossSite2-1
        child2(parent1==i)=index2;
        index2=index2+1;
    end
    for i=crossSite3:parentsBinNo(ii*2)
        if(~sum(ismember(find(parent2==i),injection1)))
            child2(parent2==i)=index2;
            index2=index2+1;
        end
    end
    index=index-1;
    index2=index2-1;
    leftouts=find(child1 == 0);
    ls=size(leftouts,2);
    for i=1:ls
        notassigned=true;
        j=1;
        while(notassigned && j<=index)
            if(sum(R_cpu(child1==j))+R_cpu(leftouts(i))<=C_cpu && sum(R_mem(child1==j))+R_mem(leftouts(i))<=C_mem && sum(R_hardDisk(child1==j))+R_hardDisk(leftouts(i))<=C_hardDisk)
                child1(leftouts(i))=j;
                notassigned=false;
            else
                j=j+1;
            end
        end
        if(notassigned)
            child1(leftouts(i))=index+1;
            index=index+1;
        end
    end
    leftouts=find(child2 == 0);
    ls=size(leftouts,2);
    for i=1:ls
        notassigned=true;
        j=1;
        while(notassigned && j<=index2)
            if(sum(R_cpu(child2==j))+R_cpu(leftouts(i))<=C_cpu && sum(R_mem(child2==j))+R_mem(leftouts(i))<=C_mem && sum(R_hardDisk(child2==j))+R_hardDisk(leftouts(i))<=C_hardDisk)
                child2(leftouts(i))=j;
                notassigned=false;
            else
                j=j+1;
            end
        end
        if(notassigned)
            child2(leftouts(i))=index2+1;
            index2=index2+1;
        end
    end
    children(ii*2-1,:)=child1;
    children(ii*2,:)=child2;
    OffBinNo(ii*2-1)=index;
    OffBinNo(ii*2)=index2;
    if(mod(row,2))
       children(row,:)=parents(row,:);
    end
end
end

