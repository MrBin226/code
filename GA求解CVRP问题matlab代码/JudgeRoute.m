%% �ж�һ��·���Ƿ�����������Լ����1��ʾ���㣬0��ʾ������
%����route��       ·��
%����demands��     �˿�������
%����cap��         �������װ����
%���flagR��       ���һ��·���Ƿ�����������Լ����1��ʾ���㣬0��ʾ������
function flagR=JudgeRoute(route,demands,cap)
flagR=1;                        %��ʼ����������Լ��
Ld=leave_load(route,demands);   %�������·�����뿪��������ʱ���ػ���
%���������������Լ������flagR��ֵΪ0
if Ld>cap
    flagR=0;
end
end