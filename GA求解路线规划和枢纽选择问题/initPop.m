function [pop] = initPop(pop_num,P_n)
%��ʼ����Ⱥ
%   pop_num:��Ⱥ��С
%   P_n:��Ŧ����
%   pop:��Ⱥ
pop=zeros(pop_num,P_n);
for i=1:pop_num
    pop(i,:)=round(rand(1,P_n));
end
end

