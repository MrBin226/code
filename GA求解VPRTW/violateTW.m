%% ���㵱ǰ��Υ����ʱ�䴰Լ��

function [w1,w2,w3]=violateTW(curr_vc,a,b,s,E,transport_time,demands,a3)
NV=size(curr_vc,1);                         %���ó�������
w1=0;
w2=0;
w3=0;
bsv=begin_s_v(curr_vc,s,transport_time);            %����ÿ��������·�����ڸ����㿪ʼ�����ʱ�䣬�����㷵�زֿ�ʱ��
for i=1:NV
    route=curr_vc{i};
    bs=bsv{i};
    l_bs=length(bsv{i});
    for j=1:l_bs-1
        if bs(j)>b(route(j))
            w2=w2+(bs(j)-b(route(j)))*demands(route(j));
        else
            if bs(j)<a(route(j))
                w1=w1+(a(route(j))-bs(j))*demands(route(j));
            end
        end
        w3=w3+(1-a3*(bs(j)-E))*demands(route(j));
    end
end
end

