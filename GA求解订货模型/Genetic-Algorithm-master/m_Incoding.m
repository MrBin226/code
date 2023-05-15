function pop=m_Incoding(binPop,r_min,r_max,q_min,q_max,pop_length)
%% 解码
popNum = 2;%染色体包含的参数数量,包含2个参数，r和Q
pop=zeros(popNum,size(binPop,2));
for n=1:size(binPop,2)
    Matrix = binPop{1,n};
    l=1;
    for num=1:popNum
        pop(num,n) = gray2bin(Matrix(l:pop_length(num)+l-1));%bin2dec将二进制字符串转化为10进制数
        l=pop_length(num)+1;
    end
end
%因为假设r的范围是[1,5]，而染色体长度有3，则一个二进制串可以表示[0,7]的数，所以需要把[0,7]映射到[1,5]
%一个[m,n]映射到[a,b]区间的转化公式是：x=(b-a)*(y-n)/(m-n)+a，其中y为[m,n]的数,x为[a,b]的数
%因为r和Q只能取整数，所以需要对映射后的值进行取整,round()函数
pop(1,:) = round(((r_max-r_min)/(2^pop_length(1)-1))*pop(1,:)+r_min);
pop(2,:) = round(((q_max-q_min)/(2^pop_length(2)-1))*pop(2,:)+q_min);
