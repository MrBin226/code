function [pop] = initPop(popsize,w,w_len)
% ��ʼ����Ⱥ
% pop = rand(popsize,w_len) * (w_max-w_min) + w_min;
pop=zeros(popsize,w_len);
for i=1:popsize
    pop(i,:)=w+rand()*2-1; 
end
end

