%% ��ʼ����Ⱥ
%����NIND��                ��Ⱥ��С
%����N��                   Ⱦɫ�峤��
%���Chrom��               ��ʼ��Ⱥ

function Chrom=InitPop(NIND,N)
Chrom=zeros(NIND,N);%���ڴ洢��Ⱥ
for j=1:NIND
    Chrom(j,:)=randperm(N);
end