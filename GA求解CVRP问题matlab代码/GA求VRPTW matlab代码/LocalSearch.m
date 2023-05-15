%% �ֲ���������
%���룺SelCh               ��ѡ��ĸ���
%���룺cusnum              �˿���Ŀ
%���룺cap                 ���������
%���룺demands             ������
%���룺a                   �˿�ʱ�䴰��ʼʱ��[a[i],b[i]]
%���룺b                   �˿�ʱ�䴰����ʱ��[a[i],b[i]]
%���룺L                   ��������ʱ�䴰����ʱ��
%���룺s                   �ͻ���ķ���ʱ��
%���룺dist                ��������������ǹ�ϵ�����þ����ʾ����c[i][j]=dist[i][j]
%�����SelCh               ������ת��ĸ���
function SelCh=LocalSearch(SelCh,cusnum,cap,cav,demands_w,demands_v,a,b,L,s,dist,alpha,belta,first_price,next_price)
D=15;                                                       %Remove�����е����Ԫ��
toRemove=15;                                                %��Ҫ�Ƴ��˿͵�����
[row,N]=size(SelCh);
for i=1:row
    [VC,NV,TD,violate_num,violate_cus]=decode(SelCh(i,:),cusnum,cap,cav,demands_w,demands_v,a,b,L,s,dist);
    CF=costFuction(VC,a,b,s,L,dist,demands_w,demands_v,cap,cav,alpha,belta,first_price,next_price);
    %Remove
    [removed,rfvc] = Remove(cusnum,toRemove,D,dist,VC);
    %Re-inserting
    [ReIfvc,RTD] = Re_inserting(removed,rfvc,L,a,b,s,dist,demands_w,demands_v,cap,cav);
    %����ͷ�����
    RCF=costFuction(ReIfvc,a,b,s,L,dist,demands_w,demands_v,cap,cav,alpha,belta,first_price,next_price);
    if RCF<CF
        chrom=change(ReIfvc,N,cusnum);
        if length(chrom)~=N
            record=ReIfvc;
            break
        end
        SelCh(i,:)=chrom;
    end
end
