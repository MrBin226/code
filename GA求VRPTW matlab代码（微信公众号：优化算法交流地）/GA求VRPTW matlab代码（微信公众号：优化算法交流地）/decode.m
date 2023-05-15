%
%      @���ߣ�����390
%      @΢�Ź��ںţ��Ż��㷨������
%
%% ����
%���룺chrom               ����
%���룺cusnum              �˿���Ŀ
%���룺cap                 ���������
%���룺demands             ������
%���룺a                   �˿�ʱ�䴰��ʼʱ��[a[i],b[i]]
%���룺b                   �˿�ʱ�䴰����ʱ��[a[i],b[i]]
%���룺L                   ��������ʱ�䴰����ʱ��
%���룺s                   �ͻ���ķ���ʱ��
%���룺dist                ��������������ǹ�ϵ�����þ����ʾ����c[i][j]=dist[i][j]
%�����VC                  ÿ�����������Ĺ˿ͣ���һ��cell����
%�����NV                  ����ʹ����Ŀ
%�����TD                  ������ʻ�ܾ���
%�����violate_num         Υ��Լ��·����Ŀ
%�����violate_cus         Υ��Լ���˿���Ŀ
function [VC,NV,TD,violate_num,violate_cus]=decode(chrom,cusnum,cap,demands,a,b,L,s,dist)
violate_num=0;                                      %Υ��Լ��·����Ŀ
violate_cus=0;                                      %Υ��Լ���˿���Ŀ
VC=cell(cusnum,1);                                  %ÿ�����������Ĺ˿�
count=1;                                            %��������������ʾ��ǰ����ʹ����Ŀ
location0=find(chrom>cusnum);                       %�ҳ��������������ĵ�λ��
for i=1:length(location0)
    if i==1                                         %��1���������ĵ�λ��
        route=chrom(1:location0(i));                %��ȡ������������֮���·��
        route(route==chrom(location0(i)))=[];       %ɾ��·���������������
    else
        route=chrom(location0(i-1):location0(i));   %��ȡ������������֮���·��
        route(route==chrom(location0(i-1)))=[];     %ɾ��·���������������
        route(route==chrom(location0(i)))=[];       %ɾ��·���������������
    end
    VC{count}=route;                                %�������ͷ���
    count=count+1;                                  %����ʹ����Ŀ
end
route=chrom(location0(end):end);                    %���һ��·��       
route(route==chrom(location0(end)))=[];             %ɾ��·���������������
VC{count}=route;                                    %�������ͷ���
[VC,NV]=deal_vehicles_customer(VC);                 %��VC�пյ������Ƴ�
for j=1:NV
    route=cell(1,1);                                %������ʱԪ���������route���洢preroute
    route{1}=VC{j};
    flag=Judge(route,cap,demands,a,b,L,s,dist);     %�жϵ�ǰ�����Ƿ�����ʱ�䴰Լ����������Լ����0��ʾΥ��Լ����1��ʾ����ȫ��Լ��
    if flag==0
        violate_cus=violate_cus+length(route{1});   %�������·��������Լ������Υ��Լ���˿���Ŀ�Ӹ���·���˿���Ŀ
        violate_num=violate_num+1;                  %�������·��������Լ������Υ��Լ��·����Ŀ��1
    end
end
TD=travel_distance(VC,dist);                        %�÷���������ʻ�ܾ���
end

