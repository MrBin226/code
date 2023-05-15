%% ����ÿ�����뿪��ǰ·���ϼ�������ʱ���ػ�����ÿ�����뿪��ǰ·����ÿһ��ʱ���ػ���
%����vehicles_customer            ÿ�����������Ĺ˿�
%����d1                           ��ʾ�ɼ����������͵��˿͵�������
%���vd                           ÿ�����뿪�������ĵ�װ����
%���vw                           ÿ�����뿪�ӹ������װ����
%���vl                           ÿ�����뿪��ǰ·���ϼ�������ʱ���ػ�����ÿ�����뿪��ǰ·����ÿһ��ʱ���ػ���
function [wl,vl]= vehicle_load( vehicles_customer,demands_w,demands_v)
n=size(vehicles_customer,1);                    %��������
wl=zeros(n,1);                                          %ÿ�����뿪��ǰ·���ϼ�������ʱ���ػ�����ÿ�����뿪��ǰ·����ÿһ��ʱ���ػ���
vl=zeros(n,1);
%% �ȼ����ÿ�����ڼ������ĳ�ʼ��װ������
for i=1:n
    route=vehicles_customer{i};
    if isempty(route)
        wl(i)=0;
        vl(i)=0;
    else
        [Ld,Lv]= leave_load( route,demands_w,demands_v);
        wl(i)=Ld;
        vl(i)=Lv;
    end
end
end