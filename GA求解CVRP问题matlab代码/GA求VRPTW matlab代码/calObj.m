%% ������Ⱥ��Ŀ�꺯��ֵ
%���룺Chrom               ��Ⱥ
%���룺cusnum              �˿���Ŀ
%���룺cap                 ���������
%���룺demands             ������
%���룺a                   �˿�ʱ�䴰��ʼʱ��[a[i],b[i]]
%���룺b                   �˿�ʱ�䴰����ʱ��[a[i],b[i]]
%���룺L                   ��������ʱ�䴰����ʱ��
%���룺s                   �ͻ���ķ���ʱ��
%���룺dist                ��������������ǹ�ϵ�����þ����ʾ����c[i][j]=dist[i][j]
%�����ObjV                ÿ�������Ŀ�꺯��ֵ������Ϊ����ʹ����Ŀ*10000+������ʻ�ܾ���
function ObjV=calObj(Chrom,cusnum,cap,cav,demands_w,demands_v,a,b,L,s,dist,alpha,belta,first_price,next_price)
% route=1:cusnum;
% G= part_length(route,dist);               %GΪ��ÿ��������·���ĳͷ�Ȩ��
NIND=size(Chrom,1);                         %��Ⱥ��Ŀ
ObjV=zeros(NIND,1);                         %����ÿ�����庯��ֵ
G=10;                                       %GΪ��ÿ��������·���ĳͷ�Ȩ��
for i=1:NIND
    [VC,NV,TD,violate_num,violate_cus]=decode(Chrom(i,:),cusnum,cap,cav,demands_w,demands_v,a,b,L,s,dist);
    costF=costFuction(VC,a,b,s,L,dist,demands_w,demands_v,cap,cav,alpha,belta,first_price,next_price);
    if violate_num>0
        ObjV(i)=costF+10000;
    else
        ObjV(i)=costF;
    end
%     ObjV(i)=NV+G*violate_cus;
end
end

