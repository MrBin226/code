%% ���㵱ǰ��ĳɱ�����
%����curr_vc                  ÿ�����������Ĺ˿�
%����a,b                      �˿�ʱ�䴰����ʱ��[a[i],b[i]]
%����s                        ��ÿ���˿͵ķ���ʱ��
%����L                        �ֿ�ʱ�䴰����ʱ��
%����dist                     �������
%����demands                  �����˿�������
%����cap                      ��������ػ���
%���cost                      �ɱ����� f=TD+alpha*q+belta*w
function [cost]=costFuction(curr_vc,a,b,s,L,dist,demands_w,demands_v,cap,cav,alpha,belta,first_price,next_price)
[TD] = travel_distance(curr_vc,dist);
[q,v]=violateLoad(curr_vc,demands_w,demands_v,cap,cav);
[w]=violateTW(curr_vc,a,b,s,L,dist);
v_p=0;
for i=1:length(curr_vc)
    if length(curr_vc{i})==1
        v_p=v_p+first_price;
    else
        v_p=v_p+(length(curr_vc{i})-1)*next_price+first_price;
    end
end
cost=TD+alpha*(q+v)+belta*w+v_p;
end

