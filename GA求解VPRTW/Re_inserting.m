%% �����Ƴ��Ĺ˿����²�����õ����µĳ����˿ͷ��䷽��
function [ ReIfvc,RTD ] = Re_inserting(removed,rfvc,L,a,b,s,dist,demands,cap)

while ~isempty(removed)
    %% ��Զ��������ʽ������С����Ŀ�������������Ԫ���ҳ���
    %     [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,L,a,b,s,dist,demands,cap );
    [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,L,a,b,s,dist,demands,cap );
    removed(removed==fv)=[];
    %% ���ݲ���㽫Ԫ�ز�ص�ԭʼ����
    [rfvc,iTD]=insert(fv,fviv,fvip,fvC,rfvc,dist);
end
[ rfvc,~ ] = deal_vehicles_customer( rfvc );

ReIfvc=rfvc;
[ RTD,~ ] = travel_distance( ReIfvc,dist );
end

