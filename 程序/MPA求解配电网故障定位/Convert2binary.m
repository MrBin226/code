function [bin] = Convert2binary(x)
%��ʵ��ת��Ϊ������
bin=zeros(size(x));
for i=1:length(x)
    if x(i)>0.5
        bin(i)=1;
    end
end

end

