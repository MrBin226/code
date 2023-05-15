function [civ,cip,C]= cheapestIP( rv,rfvc,dist,origin_dis,demands,cap)
NV=size(rfvc,1);             
outcome=[];               
for i=1:NV
    route=rfvc{i};         
    len=length(route);      
    LB= part_length(route,dist,origin_dis);
    %�Ƚ�rv���뵽route�е��κο�϶����(len+1)��,
    for j=1:len+1
        %��rv���뵽�������ĺ�
        if j==1
            temp_r=[rv route];
            LA= part_length(temp_r,dist,origin_dis);       %����rv֮�����·���ľ���
            delta=LA-LB;                       %����rv֮�����·���ľ�������
            flagR=JudgeRoute(temp_r,demands,cap);   
            if flagR==1
                outcome=[outcome;i j delta];
            end
            %��rv���뵽��������ǰ
        elseif j==len+1
            temp_r=[route rv];
            LA= part_length(temp_r,dist,origin_dis);      
            delta=LA-LB;                     
            flagR=JudgeRoute(temp_r,demands,cap);  
            if flagR==1
                outcome=[outcome;i j delta];
            end
            %��rv���뵽�˿�֮��������϶
        else
            temp_r=[route(1:j-1) rv route(j:end)];
            LA= part_length(temp_r,dist,origin_dis);    
            delta=LA-LB;                    
            flagR=JudgeRoute(temp_r,demands,cap);  
            if flagR==1
                outcome=[outcome;i j delta];
            end
        end
    end
end
if ~isempty(outcome)
    addC=outcome(:,3);                        
    [saC,sindex]=sort(addC);              
    temp=outcome(sindex,:);                 
    civ=temp(1,1);                           
    cip=temp(1,2);
    C=temp(1,3);
else
    civ=NV+1;
    cip=1;
    C=part_length(rv,dist,origin_dis);
end
end