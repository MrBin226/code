function [ifvc,iTD]=insert(fv,fviv,fvip,fvC,rfvc,dist,origin_dis)
ifvc=rfvc;
[ sumTD,~ ] = travel_distance( rfvc,dist,origin_dis );     %���ǰ���ܾ���
iTD=sumTD+fvC;                                  %��غ���ܾ���
if fviv<=size(rfvc,1)
    route=rfvc{fviv};                               %��Ԫ�ز�ص�·��
    len=length(route);
    if fvip==1
        temp=[fv route];
    elseif fvip==len+1
        temp=[route fv];
    else
        temp=[route(1:fvip-1) fv route(fvip:end)];
    end
    ifvc{fviv}=temp;
else 
    ifvc{fviv,1}=[fv];
end
end