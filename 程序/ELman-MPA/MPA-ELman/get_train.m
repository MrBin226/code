function [tr] = get_train(x,hiddNum,R,Q,threshold,p_train,t_train)

%获取权值和阈值
W1 = x(1:hiddNum*R);
B1 = x(hiddNum*R+1:hiddNum*R + hiddNum);
B2 = x(hiddNum*R + hiddNum + 1:Q + hiddNum*R + hiddNum);
%获取承接层值
LW1 = x(Q + hiddNum*R + hiddNum + 1:Q + hiddNum*R + hiddNum + hiddNum*hiddNum);
LW2 = x(Q + hiddNum*R + hiddNum + hiddNum*hiddNum + 1:Q + hiddNum*R + hiddNum + hiddNum*hiddNum+Q*hiddNum);

% 建立Elman神经网络 隐藏层为hiddNum个神经元
net=newelm(threshold,[hiddNum,Q],{'tansig','purelin'});
net.IW{1} = reshape(W1,[hiddNum,R]);
net.B{1} = B1';
net.B{2} = B2';

net.LW{1} = reshape(LW1,[hiddNum,hiddNum]);
net.LW{2} = reshape(LW2,[Q,hiddNum]);


% 设置网络训练参数
net.trainparam.epochs=100;
net.trainParam.showWindow = false; 
net.trainParam.showCommandLine = false; 


% Elman网络训练
[~,tr]=train(net,p_train,t_train);

end
