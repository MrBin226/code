%% �ֲ���������
function SelCh=LocalSearch(SelCh,cusnum,cap,customer,E,L,dist,TC1,TC2,c1,transport_time,len)
D=15;                                                       %Remove�����е����Ԫ��
toRemove=5;                                                %��Ҫ�Ƴ��˿͵�����
demands = customer(:,2);
a = customer(:,3);
b = customer(:,4);
s = customer(:,5);
[row,N]=size(SelCh);
for i=1:row
    [VC,NV,TD,violate_num,violate_cus]=decode(SelCh(i,:),cusnum,cap,demands,a,b,L,s,dist,len);
    [CF]=costFuction(VC,a,b,s,E,dist,demands,cap,TC1,TC2,c1,transport_time,NV);
    %Remove
    [removed,rfvc] = Remove(cusnum,toRemove,D,dist,VC);
    %Re-inserting
    [ReIfvc,~] = Re_inserting(removed,rfvc,L,a,b,s,dist,demands,cap,len);
    %����ͷ�����
    [RCF]=costFuction(ReIfvc,a,b,s,E,dist,demands,cap,TC1,TC2,c1,transport_time,NV);
    if RCF<CF
        chrom=change(ReIfvc,N,cusnum);
        if length(chrom)~=N
            record=ReIfvc;
            break
        end
        SelCh(i,:)=chrom;
    end
end
