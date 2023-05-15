%% 删除种群中重复个体，并补齐删除的个体
% 输入Chrom：种群
% 输出dChrom：处理掉重复个体的种群
function dChrom=deal_Repeat(Chrom,shelve_num)
N=size(Chrom,1);                                    %种群数目
len=size(Chrom,2);                                  %染色体长度
dChrom=unique(Chrom,'rows');                        %删除重复数组对
Nd=size(dChrom,1);                                  %剩余个体数目
while N-Nd>0
    newChrom=initPoP(N-Nd,len,shelve_num);
    dChrom=[dChrom;newChrom];
    dChrom=unique(dChrom,'rows');                        %删除重复数组对
    Nd=size(dChrom,1);                                  %剩余个体数目
end
end

