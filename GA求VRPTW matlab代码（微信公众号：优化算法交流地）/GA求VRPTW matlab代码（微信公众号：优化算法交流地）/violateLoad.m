%
%      @���ߣ�����390
%      @΢�Ź��ںţ��Ż��㷨������
%
%% ���㵱ǰ��Υ��������Լ��
%����curr_vc                  ��ǰ��
%����demands                  �����˿�������
%����cap                      ��������ػ���
%���q                        ����·��Υ���ػ���֮��
function [q]=violateLoad(curr_vc,demands,cap)
NV=size(curr_vc,1);                     %���ó�����Ŀ
q=0;
for i=1:NV
    route=curr_vc{i};
    Ld=leave_load(route,demands);
    if Ld>cap
        q=q+Ld-cap;
    end
end
end

