%% ����ĳһ��·�����뿪�������ĺ͹˿�ʱ���ػ���
%����route��               һ������·��
%����demands��             ��ʾ�ɼ����������͵��˿͵�������
%���Ld��                  ��ʾ�����뿪��������ʱ���ػ���
function [Ld,Lv]=leave_load( route,demands_w,demands_v)
n=length(route);                            %����·�߾����ӹ�����Ͱ�װ���ص�������
Ld=0;                                       %��ʼ�����ڼ�������ʱ��װ����Ϊ0
Lv=0;
if n~=0
    for i=1:n
        if route(i)~=0
            Ld=Ld+demands_w(route(i));
            Lv=Lv+demands_v(route(i));
        end
    end
end
end

