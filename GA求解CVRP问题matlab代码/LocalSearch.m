%% 局部搜索函数
%输入：SelCh               被选择的个体
%输入：cusnum              顾客数目
%输入：cap                 最大载重量
%输入：demands             需求量
%输入：dist                距离矩阵，满足三角关系，暂用距离表示花费c[i][j]=dist[i][j]
%输出：SelCh               进化逆转后的个体
function SelCh=LocalSearch(SelCh,cusnum,cap,demands,dist,alpha)
D=15;                                                       %Remove过程中的随机元素
toRemove=min(ceil(cusnum/2),15);                            %将要移出顾客的数量
[row,N]=size(SelCh);
for i=1:row
    VC=decode(SelCh(i,:),cusnum,cap,demands,dist);
    CF=costFuction(VC,dist,demands,cap,alpha);
    %Remove
    [removed,rfvc] = Remove(cusnum,toRemove,D,dist,VC);
    %Re-inserting
    [ ReIfvc,RTD ] = Re_inserting(removed,rfvc,dist,demands,cap);
    %计算惩罚函数
    RCF=costFuction(ReIfvc,dist,demands,cap,alpha);
    if RCF<CF
        chrom=change(ReIfvc,N,cusnum);
        SelCh(i,:)=chrom;
    end
end
