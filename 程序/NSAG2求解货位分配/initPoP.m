function [pop] = initPoP(pop_size,chrome_length,shelve_num)
%UNTITLED ��ʼ������
%   �˴���ʾ��ϸ˵��
pop = zeros(pop_size,chrome_length);
for i=1:pop_size
    pop(i,:)=randperm(shelve_num,chrome_length);
end

end

