function [parents,parentsBinNo,indices] = GGA_select(chromosome,parentssize,fitnesses,BinNo)
[N,~]=size(chromosome);
indices=zeros(parentssize,1);
parents=cell(parentssize,1);
parentsBinNo=zeros(parentssize,1);
[~,idx]=min(fitnesses);
for kk=1:BinNo(idx)
    parents{1,kk}=chromosome{idx,kk};
end
indices(1)=idx;
parentsBinNo(1)=BinNo(idx);
for i=2:parentssize
    j=randi(N,1,2);
    if (fitnesses(j(1))<=fitnesses(j(2)))
        for kk=1:BinNo(j(1))
            parents{i,kk}=chromosome{j(1),kk};
        end
        parentsBinNo(i)=BinNo(j(1));
        indices(i)=j(1);
    else
        for kk=1:BinNo(j(2))
            parents{i,kk}=chromosome{j(2),kk};
        end
        parentsBinNo(i)=BinNo(j(2));
        indices(i)=j(2);
    end
end
end

