%% 局部搜索函数
function SelCh=LocalSearch(SelCh,cusnum,cap,customer,E,L,dist,a1,a2,a3,C1k,C2k,transport_time)
D=15;                                                       %Remove过程中的随机元素
toRemove=5;                                                %将要移出顾客的数量
demands = customer(:,2);
a = customer(:,3);
b = customer(:,4);
s = customer(:,5);
[row,N]=size(SelCh);
for i=1:row
    [VC,NV,TD,violate_num,violate_cus]=decode(SelCh(i,:),cusnum,cap,demands,a,b,L,s,dist);
    [CF1,CF2]=costFuction(VC,a,b,s,E,dist,demands,cap,a1,a2,a3,C1k,C2k,transport_time,NV);
    %Remove
    [removed,rfvc] = Remove(cusnum,toRemove,D,dist,VC);
    %Re-inserting
    [ReIfvc,~] = Re_inserting(removed,rfvc,L,a,b,s,dist,demands,cap);
    %计算惩罚函数
    [RCF1,RCF2]=costFuction(ReIfvc,a,b,s,E,dist,demands,cap,a1,a2,a3,C1k,C2k,transport_time,NV);
    if RCF1<CF1 && RCF2>CF2
        chrom=change(ReIfvc,N,cusnum);
        if length(chrom)~=N
            record=ReIfvc;
            break
        end
        SelCh(i,:)=chrom;
    end
end
