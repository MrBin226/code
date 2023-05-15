%输入：
%a和b为两个待交叉的个体
%输出：
%a和b为交叉后得到的两个个体
function [a1,b1]=OX(a,b)
num=length(a);
ind=[randi([1,floor(length(a)/2)],1),randi([floor(length(a)/2)+1,length(a)],1)];
% ind=[2,3];
a1=b(ind(1):ind(2));
b1=a(ind(1):ind(2));
a0=a;
b0=b;
a0=setdiff(a0,a1);
b0=setdiff(b0,b1);
if length(a0)>num-ind(2)+ind(1)-1
    for i=1:length(b1)
        a0(a0==b1(i))=[];
        if length(a0)==num-ind(2)+ind(1)-1
            break;
        end
    end
end
if length(b0)>num-ind(2)+ind(1)-1
    for i=1:length(a1)
        b0(b0==a1(i))=[];
        if length(b0)==num-ind(2)+ind(1)-1
            break;
        end
    end
end
a1=[a0(1:ind(1)-1) a1 a0(ind(1):end)];
b1=[b0(1:ind(1)-1) b1 b0(ind(1):end)];
end


