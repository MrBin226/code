%
%      @���ߣ�����390
%      @΢�Ź��ںţ��Ż��㷨������
%
%% ���㵱ǰ��ĳɱ�����
%����curr_vc                  ÿ�����������Ĺ˿�
%����a,b                      �˿�ʱ�䴰����ʱ��[a[i],b[i]]
%����s                        ��ÿ���˿͵ķ���ʱ��
%����L                        �ֿ�ʱ�䴰����ʱ��
%����dist                     �������
%����demands                  �����˿�������
%����cap                      ��������ػ���
%���cost                      �ɱ����� f=TD+alpha*q+belta*w
function [cost]=costFuction(curr_vc,a,b,s,L,dist,demands,cap,alpha,belta)
[TD] = travel_distance(curr_vc,dist);
[q]=violateLoad(curr_vc,demands,cap);
[w]=violateTW(curr_vc,a,b,s,L,dist);
cost=TD+alpha*q+belta*w;
end

