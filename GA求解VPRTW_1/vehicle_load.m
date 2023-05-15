%% ����ÿ�����뿪��ǰ·���ϼ�������ʱ���ػ�����ÿ�����뿪��ǰ·����ÿһ��ʱ���ػ���
function [vl,dl]= vehicle_load(vehicles_customer,demands,dist)
n=size(vehicles_customer,1);                    %��������
vl=zeros(n,1);                                          %ÿ�����뿪��ǰ·���ϼ�������ʱ���ػ�����ÿ�����뿪��ǰ·����ÿһ��ʱ���ػ���
dl=zeros(n,1);
%% �ȼ����ÿ�����ڼ������ĳ�ʼ��װ������
for i=1:n
    route=vehicles_customer{i};
    if isempty(route)
        vl(i)=0;
        dl(i)=0;
    else
        [Ld,d]= leave_load( route,demands,dist);
        vl(i)=Ld;
        dl(i)=d;
    end
end
end