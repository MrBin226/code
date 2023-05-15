function [route] = decode(gen,c,f,l,a1,a2,first_end,P,c_kt)
%解码函数
%   gen：个体
%   c：运输费用
%   f：需求量
%   l：运输距离
%   route:路线
node=size(f,1);
route={};
count=1;
for i=1:node
    if isempty(first_end{i})
        continue
    end
    temp=first_end{i};
    for j=1:length(first_end{i})
        route{count}=get_route(i,temp(j),f,l,c,a1,a2,gen,P,c_kt);
        count=count+1;
    end
end
end

