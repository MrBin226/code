%% �ֲ���������
%���룺SelCh               ��ѡ��ĸ���
%���룺cusnum              �˿���Ŀ
%���룺cap                 ���������
%���룺demands             ������
%���룺dist                ��������������ǹ�ϵ�����þ����ʾ����c[i][j]=dist[i][j]
%�����SelCh               ������ת��ĸ���
function SelCh=LocalSearch(SelCh,cusnum,cap,demands,dist,alpha)
D=15;                                                       %Remove�����е����Ԫ��
toRemove=min(ceil(cusnum/2),15);                            %��Ҫ�Ƴ��˿͵�����
[row,N]=size(SelCh);
for i=1:row
    VC=decode(SelCh(i,:),cusnum,cap,demands,dist);
    CF=costFuction(VC,dist,demands,cap,alpha);
    %Remove
    [removed,rfvc] = Remove(cusnum,toRemove,D,dist,VC);
    %Re-inserting
    [ ReIfvc,RTD ] = Re_inserting(removed,rfvc,dist,demands,cap);
    %����ͷ�����
    RCF=costFuction(ReIfvc,dist,demands,cap,alpha);
    if RCF<CF
        chrom=change(ReIfvc,N,cusnum);
        SelCh(i,:)=chrom;
    end
end
