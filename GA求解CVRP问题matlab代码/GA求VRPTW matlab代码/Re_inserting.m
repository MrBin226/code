%% �����Ƴ��Ĺ˿����²�����õ����µĳ����˿ͷ��䷽��
%%����removed                         ���Ƴ��Ĺ˿ͼ���
%����rfvc                             �Ƴ�removed�еĹ˿ͺ��final_vehicles_customer
%����L                                ��������ʱ�䴰
%����a                                �˿�ʱ�䴰
%����b                                �˿�ʱ�䴰
%����s                                ����ÿ���˿͵�ʱ��
%����dist                             �������
%����demands                          ������
%����cap                              ���������
%���ReIfvc                           �����Ƴ��Ĺ˿����²�����õ����µĳ����˿ͷ��䷽��
%���RTD                              �·��䷽�����ܾ���
function [ ReIfvc,RTD ] = Re_inserting(removed,rfvc,L,a,b,s,dist,demands_w,demands_v,cap,cav)

while ~isempty(removed)
    %% ��Զ��������ʽ������С����Ŀ�������������Ԫ���ҳ���
    %     [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,L,a,b,s,dist,demands,cap );
    [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,L,a,b,s,dist,demands_w,demands_v,cap,cav );
    removed(removed==fv)=[];
    %% ���ݲ���㽫Ԫ�ز�ص�ԭʼ����
    [rfvc,iTD]=insert(fv,fviv,fvip,fvC,rfvc,dist);
end
[ rfvc,~ ] = deal_vehicles_customer( rfvc );

ReIfvc=rfvc;
[ RTD,~ ] = travel_distance( ReIfvc,dist );
end

