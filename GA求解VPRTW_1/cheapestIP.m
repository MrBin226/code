
%% �ҳ�Removed��������һ��Ԫ�ص�cheapest insertion point
%��һ�������ҳ�����ʱ�䴰Լ��������Լ�������в���㣬�ټ������������ľ�������
%�ڶ������ҳ�������������������С���Ǹ���Ѳ���㣬����¼��������
function [civ,cip,C]= cheapestIP( rv,rfvc,L,a,b,s,dist,demands,cap,len)
NV=size(rfvc,1);              %���ó�����
outcome=[];                 %�洢ÿһ������Ĳ�����Լ���Ӧ�ľ������� [������� �������� ��������]
for i=1:NV
    route=rfvc{i};          %���е�һ��·��
    len=length(route);      %��·�����������˿�����
    LB= part_length(route,dist);       %����rv֮ǰ����·���ľ���
    %�Ƚ�rv���뵽route�е��κο�϶����(len+1)��,
    for j=1:len+1
        %��rv���뵽�������ĺ�
        if j==1
            temp_r=[rv route];
            LA= part_length(temp_r,dist);       %����rv֮�����·���ľ���
            delta=LA-LB;                       %����rv֮�����·���ľ�������
            [Ld,d]=leave_load( temp_r,demands,dist);
            %���ͬʱ����ʱ�䴰Լ��������Լ������ò�����������¼����
            if (Ld<=cap)&&(d<=len)
                outcome=[outcome;i j delta];
            end
            %��rv���뵽��������ǰ
        elseif j==len+1
            temp_r=[route rv];
            LA= part_length(temp_r,dist);       %����rv֮�����·���ľ���
            delta=LA-LB;                       %����rv֮�����·���ľ�������
            [Ld,d]=leave_load( temp_r,demands,dist);
            %���ͬʱ����ʱ�䴰Լ��������Լ������ò�����������¼����
            if (Ld<=cap)&&(d<=len)
                outcome=[outcome;i j delta];
            end
            %��rv���뵽�˿�֮��������϶
        else
            temp_r=[route(1:j-1) rv route(j:end)];
            LA= part_length(temp_r,dist);       %����rv֮�����·���ľ���
            delta=LA-LB;                       %����rv֮�����·���ľ�������
            [Ld,d]=leave_load( temp_r,demands,dist);
            %���ͬʱ����ʱ�䴰Լ��������Լ������ò�����������¼����
            if (Ld<=cap)&&(d<=len)
                outcome=[outcome;i j delta];
            end
        end
    end
end
%% ������ں���Ĳ���㣬���ҳ����Ų���㣬����������һ��������
if ~isempty(outcome)
    addC=outcome(:,3);                          %ÿ�������ľ�������
    [saC,sindex]=sort(addC);                    %������������С��������
    temp=outcome(sindex,:);                     %������������С����������[������� �������� ��������]
    civ=temp(1,1);                              %��һ�м�Ϊ��Ѳ�����Լ���Ӧ�ľ�������
    cip=temp(1,2);
    C=temp(1,3);
else
    civ=NV+1;
    cip=1;
    C=part_length(rv,dist);
end

end

