function [bin] = Convert2binary(x)
%将实数转化为二进制
bin=zeros(size(x));
for i=1:length(x)
    if x(i)>0.5
        bin(i)=1;
    end
end

end

