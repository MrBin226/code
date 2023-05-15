function [parents,parentsBinNo,indices] = select(chromosome,select_rate,fitnesses,BinNo)
[N,m]=size(chromosome);
parentssize=N*select_rate;
indices=zeros(parentssize,1);
parents=zeros(parentssize,m);
parentsBinNo=zeros(parentssize,1);
[~,idx]=min(fitnesses);
parents(1,:)=chromosome(idx,:);
indices(1)=idx;
parentsBinNo(1)=BinNo(idx);
for i=2:parentssize
    j=randi(N,1,2);
    if (fitnesses(j(1))<=fitnesses(j(2)))
        parents(i,:)=chromosome(j(1),:);
        parentsBinNo(i)=BinNo(j(1));
        indices(i)=j(1);
    else
        parents(i,:)=chromosome(j(2),:);
        parentsBinNo(i)=BinNo(j(2));
        indices(i)=j(2);
    end
end
end
