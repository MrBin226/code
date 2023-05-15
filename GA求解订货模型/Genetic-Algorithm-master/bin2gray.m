function [Gray] = bin2gray(Bin)
%二进制转化为格雷码
len = length(Bin);
Gray(1) = Bin(1);
for i = 2 : len
tmp1 = str2num(Bin(i-1));
tmp2 = str2num(Bin(i));
Gray(i) = num2str(xor(tmp1, tmp2));
end