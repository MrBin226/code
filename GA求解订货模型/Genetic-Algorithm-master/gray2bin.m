function [num]=gray2bin(gray)
    %格雷码先转化为二进制，再转化为10进制
    len = length(gray);
    bin(1) = gray(1);
    for i=2:len
        temp1 = str2num(gray(i));
        temp2 = str2num(bin(i-1));
        bin(i) = num2str(xor(temp1,temp2));
    end
    num = bin2dec(bin);
end