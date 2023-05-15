%% 初始化种群
%输入NIND：                种群大小
%输入N：                   染色体长度
%输出Chrom：               初始种群

function Chrom=InitPop(NIND,N)
Chrom=zeros(NIND,N);%用于存储种群
for j=1:NIND
    Chrom(j,:)=randperm(N);
end