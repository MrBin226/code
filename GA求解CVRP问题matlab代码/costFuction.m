%% ���㵱ǰ��ĳɱ�����
%����VC                       ÿ�����������Ĺ˿�
%����dist                     �������
%����demands                  �����˿�������
%����cap                      ��������ػ���
%���cost                      �ɱ����� f=TD+alpha*q
function cost=costFuction(VC,dist,demands,cap,alpha)
TD=travel_distance(VC,dist);
q=violateLoad(VC,demands,cap);
cost=TD+alpha*q;
end