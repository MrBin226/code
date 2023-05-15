%% ��Ӧ�Ⱥ������Բ��Լ��ľ���������Ϊ��Ӧ��ֵ
function [fitness,net] = fun(x,hiddNum,R,Q,threshold,p_train,t_train,p_test,t_test,mint,maxt)

%��ȡȨֵ����ֵ
W1 = x(1:hiddNum*R);
B1 = x(hiddNum*R+1:hiddNum*R + hiddNum);
B2 = x(hiddNum*R + hiddNum + 1:Q + hiddNum*R + hiddNum);
%��ȡ�нӲ�ֵ
LW1 = x(Q + hiddNum*R + hiddNum + 1:Q + hiddNum*R + hiddNum + hiddNum*hiddNum);
LW2 = x(Q + hiddNum*R + hiddNum + hiddNum*hiddNum + 1:Q + hiddNum*R + hiddNum + hiddNum*hiddNum+Q*hiddNum);

% ����Elman������ ���ز�ΪhiddNum����Ԫ
net=newelm(threshold,[hiddNum,Q],{'tansig','purelin'});
net.IW{1} = reshape(W1,[hiddNum,R]);
net.B{1} = B1';
net.B{2} = B2';

net.LW{1} = reshape(LW1,[hiddNum,hiddNum]);
net.LW{2} = reshape(LW2,[Q,hiddNum]);


% ��������ѵ������
net.trainparam.epochs=100;
net.trainParam.showWindow = false; 
net.trainParam.showCommandLine = false; 


% Elman����ѵ��
net=train(net,p_train,t_train);
% Ԥ������
y=sim(net,p_test);
y=postmnmx(y,mint,maxt);
% �������
error = y'-t_test;
fitness = sum(sum(abs(error)));

end