%% ����ĳһ��·�����뿪��������ʱ���ػ���
%����route��               һ������·��
%����demands��             ��ʾ�������������͵��˿͵�������
%���Ld��                  ��ʾ�����뿪��������ʱ���ػ���
function Ld=leave_load(route,demands)
n=length(route);                            %����·�߾����˿͵�������
Ld=0;                                       %��ʼ��������������ʱ��װ����Ϊ0
if n~=0
    for i=1:n
        if route(i)~=0
            Ld=Ld+demands(route(i));
        end
    end
end
end