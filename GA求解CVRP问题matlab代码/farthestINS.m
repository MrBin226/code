%% ��Զ��������ʽ������С����Ŀ�������������Ԫ���ҳ���
%����removed                          ���Ƴ��Ĺ˿ͼ���
%����rfvc                             �Ƴ�removed�еĹ˿ͺ��final_vehicles_customer
%����dist                             �������
%����demands                          ������
%����cap                              ���������
%���fv                               ��removed������Ԫ�� ��Ѳ���������������Ԫ��
%���fviv                             ��Ԫ��������ĳ���
%���fvip                             ��Ԫ��������ĳ���������
%���fvC                              ��Ԫ�ز������λ�ú�ľ�������
function [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,dist,demands,cap )
nr=length(removed);                   %���Ƴ��Ĺ˿͵�����
outcome=zeros(nr,3);
for i=1:nr
    %[������� �������� ��������]
    [civ,cip,C]= cheapestIP( removed(i),rfvc,dist,demands,cap);
    outcome(i,1)=civ;
    outcome(i,2)=cip;
    outcome(i,3)=C;
end
[mc,mc_index]=max(outcome(:,3));
temp=outcome(mc_index,:);
fviv=temp(1,1);
fvip=temp(1,2);
fvC=temp(1,3);
fv=removed(mc_index);

end

