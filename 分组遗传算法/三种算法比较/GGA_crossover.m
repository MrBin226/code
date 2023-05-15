function [offspring,OffBinNo]=GGA_crossover(parents,parentssize,parentsBinNo,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk)
offspring=cell(parentssize,1);
offsize=floor(parentssize/2);
OffBinNo=zeros(parentssize,1);
%% 交叉
for ii=1:offsize
    parent1=cell(1,parentsBinNo(ii*2-1));
    parent2=cell(1,parentsBinNo(ii*2));
    for j=1:parentsBinNo(ii*2-1)
        parent1{j}=parents{ii*2-1,j};
    end
    for j=1:parentsBinNo(ii*2)
        parent2{j}=parents{ii*2,j};
    end

%% 产生交叉位置
crossSite1=randi(parentsBinNo(ii*2-1)+1);
crossSite2=randi(parentsBinNo(ii*2-1)-crossSite1+2)+crossSite1-1;

crossSite3=randi(parentsBinNo(ii*2)+1);
crossSite4=randi(parentsBinNo(ii*2)-crossSite3+2)+crossSite3-1;

injection1=[];
injection2=[];
for i=crossSite1:crossSite2-1
    injection1=[injection1,parent1{i}];
end
for i=crossSite3:crossSite4-1
    injection2=[injection2,parent2{i}];
end

child1=cell(1);
child2=cell(1);

% 生成第一个子代
index=1;
% if(crossSite1~=1)
    for i=1:crossSite2-1
        if(~sum(ismember(parent1{i},injection2)))
        child1{index}=parent1{i};
        index=index+1;
        end
    end
% end        
    for i=crossSite3:crossSite4-1
        child1{index}=parent2{i};
        index=index+1;
    end
    
    
    for i=crossSite2:parentsBinNo(ii*2-1)
        if(~sum(ismember(parent1{i},injection2)))
        child1{index}=parent1{i};
        index=index+1;
        end
    end
% 生成第二个子代
    index2=1;
% if(crossSite3~=1)
    for i=1:crossSite3-1
        if(~sum(ismember(parent2{i},injection1)))
        child2{index2}=parent2{i};
        index2=index2+1;
        end
    end
% end        
    for i=crossSite1:crossSite2-1
        child2{index2}=parent1{i};
        index2=index2+1;
    end
    
    
    for i=crossSite3:parentsBinNo(ii*2)
        if(~sum(ismember(parent2{i},injection1)))
        child2{index2}=parent2{i};
        index2=index2+1;
        end
    end
    index=index-1;
    index2=index2-1;
%% 计算第一个子代中未包含的元素
    elements=[];
    for i=1:index
        elements=[elements,child1{i}];
    end
    all=1:itemno;
    leftouts=~ismember(all,elements);
    leftouts=all(leftouts);
    ls=size(leftouts,2);
%% 将第一个子代中未包含的元素分配到机器上
    for i=1:ls
        notassigned=true;
        j=1;
        while(notassigned && j<=index)
            if(sum(R_cpu(child1{j}))+R_cpu(leftouts(i))<=C_cpu && sum(R_mem(child1{j}))+R_mem(leftouts(i))<=C_mem && sum(R_hardDisk(child1{j}))+R_hardDisk(leftouts(i))<=C_hardDisk)
                child1{j}=[child1{j},leftouts(i)];
                notassigned=false;
            else
                j=j+1;
            end
        end
        if(notassigned)
            child1{index+1}=leftouts(i);
            index=index+1;
        end
    end
     %% Calculating Leftouts for second child
    elements=[];
    for i=1:index2
        elements=[elements,child2{i}];
    end
    all=1:itemno;
    leftouts=~ismember(all,elements);
    leftouts=all(leftouts);
    ls=size(leftouts,2);
    %% Assigning Leftouts of the second child
    
    
    for i=1:ls
        notassigned=true;
        j=1;
        while(notassigned && j<=index2)
            if(sum(R_cpu(child2{j}))+R_cpu(leftouts(i))<=C_cpu && sum(R_mem(child2{j}))+R_mem(leftouts(i))<=C_mem && sum(R_hardDisk(child2{j}))+R_hardDisk(leftouts(i))<=C_hardDisk)
                child2{j}=[child2{j},leftouts(i)];
                notassigned=false;
            else
                j=j+1;
            end
        end
        if(notassigned)
            child2{index2+1}=leftouts(i);
            index2=index2+1;
        end
    end
    for i=1:index
        offspring{ii*2-1,i}=child1{i};
    end
    for i=1:index2
        offspring{ii*2,i}=child2{i};
    end
    OffBinNo(ii*2-1)=index;
    OffBinNo(ii*2)=index2;
    if(mod(parentssize,2))
        for i=1:parentsBinNo(end)
            offspring{parentssize,i}=parents{parentssize,i};
        end
    end
end
end