function [ ReIfvc,RTD ] = Re_inserting(removed,rfvc,dist,origin_dis,demands,cap)
while ~isempty(removed)
    %% ��Զ��������ʽ������С����Ŀ�������������Ԫ���ҳ���
   	[fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,dist,origin_dis,demands,cap );
    removed(removed==fv)=[];
    %% ���ݲ���㽫Ԫ�ز�ص�ԭʼ����
    [rfvc,iTD]=insert(fv,fviv,fvip,fvC,rfvc,dist,origin_dis);
end
[ rfvc,~ ] = deal_vehicles_customer( rfvc );

ReIfvc=rfvc;
[ RTD,~ ] = travel_distance( ReIfvc,dist ,origin_dis);
end

