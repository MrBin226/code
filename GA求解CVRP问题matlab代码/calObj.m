%% ������Ⱥ��Ŀ�꺯��ֵ
%���룺Chrom               ��Ⱥ
%���룺cusnum              �˿���Ŀ
%���룺cap                 ���������
%���룺demands             ������
%���룺dist                ��������������ǹ�ϵ�����þ����ʾ����c[i][j]=dist[i][j]
%�����ObjV                ÿ�������Ŀ�꺯��ֵ������Ϊ����ʹ����Ŀ*10000+������ʻ�ܾ���
function ObjV=calObj(Chrom,cusnum,cap,demands,dist,alpha)
NIND=size(Chrom,1);                         %��Ⱥ��Ŀ
ObjV=zeros(NIND,1);                         %����ÿ�����庯��ֵ
for i=1:NIND
    VC=decode(Chrom(i,:),cusnum,cap,demands,dist);
    costF=costFuction(VC,dist,demands,cap,alpha);
    ObjV(i)=costF;
end
end