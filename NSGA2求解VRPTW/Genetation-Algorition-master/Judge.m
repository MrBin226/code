%% �жϵ�ǰ�����Ƿ�����������Լ����0��ʾΥ��Լ����1��ʾ����ȫ��Լ��
function flag=Judge(VC,cap,demands)
flag=1;                         %��������Լ��
NV=size(VC,1);                  %����ʹ����Ŀ
%% ����ÿ������װ����
init_v=vehicle_load(VC,demands);

%% ����ÿ��·����һ����һ��·��������Լ����flag=0
for i=1:NV
    if init_v(i)>cap
        flag=0;
        break
    end
end
end

