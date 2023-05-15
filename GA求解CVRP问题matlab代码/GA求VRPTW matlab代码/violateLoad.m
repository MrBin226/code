%% ���㵱ǰ��Υ��������Լ��
%����curr_vc                  ��ǰ��
%����demands                  �����˿�������
%����cap                      ��������ػ���
%���q                        ����·��Υ���ػ���֮��
function [q,v]=violateLoad(curr_vc,demands_w,demands_v,cap,cav)
NV=size(curr_vc,1);                     %���ó�����Ŀ
q=0;
v=0;
for i=1:NV
    route=curr_vc{i};
    [Ld,Lv]= leave_load( route,demands_w,demands_v);
    if Ld>cap
        q=q+Ld-cap;
    end
    if Lv>cav
        v=v+Lv-cav;
    end
end
end

