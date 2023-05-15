%
%      @���ߣ�����390
%      @΢�Ź��ںţ��Ż��㷨������
%
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
function SelCh=LocalSearch(SelCh,cusnum,cap,demands,a,b,L,s,dist,alpha,belta)
D=15;                                                       %Remove�����е����Ԫ��
toRemove=15;                                                %��Ҫ�Ƴ��˿͵�����
[row,N]=size(SelCh);
for i=1:row
    [VC,NV,TD,violate_num,violate_cus]=decode(SelCh(i,:),cusnum,cap,demands,a,b,L,s,dist);
    CF=costFuction(VC,a,b,s,L,dist,demands,cap,alpha,belta);
    %Remove
    [removed,rfvc] = Remove(cusnum,toRemove,D,dist,VC);
    %Re-inserting
    [ReIfvc,RTD] = Re_inserting(removed,rfvc,L,a,b,s,dist,demands,cap);
    %����ͷ�����
    RCF=costFuction(ReIfvc,a,b,s,L,dist,demands,cap,alpha,belta);
    if RCF<CF
        chrom=change(ReIfvc,N,cusnum);
        if length(chrom)~=N
            record=ReIfvc;
            break
        end
        SelCh(i,:)=chrom;
    end
end
