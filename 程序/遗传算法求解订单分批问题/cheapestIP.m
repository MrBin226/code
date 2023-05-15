function [civ,cip,C]= cheapestIP( rv,rfvc,dist,origin_dis,demands,cap)
NV=size(rfvc,1);             
outcome=[];               
for i=1:NV
    route=rfvc{i};         
    len=length(route);      
    LB= part_length(route,dist,origin_dis);
    %先将rv插入到route中的任何空隙，共(len+1)个,
    for j=1:len+1
        %将rv插入到集配中心后
        if j==1
            temp_r=[rv route];
            LA= part_length(temp_r,dist,origin_dis);       %插入rv之后该条路径的距离
            delta=LA-LB;                       %插入rv之后该条路径的距离增量
            flagR=JudgeRoute(temp_r,demands,cap);   
            if flagR==1
                outcome=[outcome;i j delta];
            end
            %将rv插入到集配中心前
        elseif j==len+1
            temp_r=[route rv];
            LA= part_length(temp_r,dist,origin_dis);      
            delta=LA-LB;                     
            flagR=JudgeRoute(temp_r,demands,cap);  
            if flagR==1
                outcome=[outcome;i j delta];
            end
            %将rv插入到顾客之间的任意空隙
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