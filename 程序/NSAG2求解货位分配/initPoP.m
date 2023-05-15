function [pop] = initPoP(pop_size,chrome_length,shelve_num)
%UNTITLED 初始化函数
%   此处显示详细说明
pop = zeros(pop_size,chrome_length);
for i=1:pop_size
    pop(i,:)=randperm(shelve_num,chrome_length);
end

end

