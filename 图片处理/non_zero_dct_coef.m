function  [dst,n_mat] = non_zero_dct_coef(dct_coef)
src=imread('lena.jpg');%读取图片lena.jpg
% dct_coef=imread('lena_cipher.jpg');%读取lena_cipher.jpg
r1 = 11;
r2 = 39;
s = size(dct_coef);%获取dct_coef的行数和列数
dst = zeros(s);%生成一个和dct_coef行列数相同的矩阵，其中矩阵的元素全为0
temp = zeros(8);%生成一个8*8,全为0的矩阵
quant_table = [16 11 10 16 24 40 51 61 ; 
    12 12 14 19 26 58 60 55 ; 
     14 13 16 24 40 57 69 56 ; 
     14 17 22 29 51 87 80 62 ; 
     18 22 37 56 68 109 103 77;
     24 35 55 64 81 104 113 92; 
     49 64 78 87 103 121 120 101; 
     72 92 95 98 112 100 103 99];
dct_quant_src=quant_DCT(src,quant_table);%调用quant_DCT函数
% dst_count_src=non_zero_dct_coef(dct_quant_src); %代码执行到这，不断的调用non_zero_dct_coef函数，永远无法往下继续执行
% imshow(dst_count_src);
n_mat = zeros(s(1),s(2));%产生一个s(1)行s(2)列的全为0的矩阵
for i=1:8:s(1)
    for j=1:8:s(2)
        temp = dct_quant_src(i:i+7,j:j+7);% 获取 dct_coef的一个8*8的子矩阵
        temp_dst = zeros(8); %产生一个8*8的全为0的矩阵
        n = length(find(temp)); %find(temp)获取temp全部元素的索引，length(find(temp))表示索引的数量
        dst(i:i+7,j:j+7) = temp_dst; %令dst的一个8*8的子矩阵等于temp_dst
        n_mat(i:i+7,j:j+7)=n*ones(8); 
        %ones(8)产生一个8*8的全为1的矩阵
        %n*ones(8)得到一个8*8全为n的矩阵
        %令n_mat的一个8*8的子矩阵等于一个8*8全为n的矩阵
    end
end
