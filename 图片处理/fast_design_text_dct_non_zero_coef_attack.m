function n_mat = fast_design_text_dct_non_zero_coef_attack(attack_cipher_img)
tic; %记录当前时间，以便对程序运行时间进行输出
attack_cipher_img_dct = quant_DCT(attack_cipher_img);%将attack_cipher_img进行DCT变换
imshow(attack_cipher_img_dct);
attack_result = 0*attack_cipher_img_dct;%0与矩阵attack_cipher_img_dct的每个元素相乘，得到一个与attack_cipher_img_dct行列数相同的全零矩阵
attack_block = attack_result;%attack_block等于attack_result
s = size(attack_cipher_img_dct);%得到attack_cipher_img_dct的行与列，s（1）代表行，s（2）代表列
s1 = floor(s(1)/8);%s(1)/8并向下取整，即floor（4.8）=4
s2 = floor(s(2)/8);
ss1 = floor(s1/8);
ss2 = floor(s2/8);
designed_plain_text = 0*attack_cipher_img_dct;%得到一个与矩阵attack_cipher_img_dct行列数相同的全零矩阵
cell_dpt = cell(s1,s2);%生成一个s1行，s2列的元胞矩阵
%一般图像像素点数不会超过64*2^64这么多，因此只需要一幅设计明文图像
r = 1;%8*8块的行计数
c = 1;%8*8块的列计数
temp_vector = zeros(64,1);%生成一个64行，1列的全零矩阵
temp_block = zeros(8);%生成一个含有8个0元素的向量
for c = 1:s2
    for r = 1:s1
        temp_vector = zeros(64,1);%生成一个64行，1列的全零矩阵
        address = r+s2*(c-1);%r+s2*(c-1)
        binStr = dec2bin(address,64);%将address转化为二进制数字符串，如果转化的二进制数的位数小于64，则在前面补0，例如dec2bin(4,4)，4转化为二进制为100，位数为3小于4，则补0变为0100
        temp_vector = double(binStr-'0');%将二进制字符串binStr转化为矩阵，如double('0100'-'0')=[0,1,0,0]
      temp_block = reshape(temp_vector,8,8);%将temp_vector变为8行8列的矩阵
      designed_plain_text((r-1)*8+1:r*8,(c-1)*8+1:c*8) = temp_block; 
      % designed_plain_text矩阵的其中一个8行8列的分矩阵取出来，令其等于temp_block，即假设c=1，r=1时，designed_plain_text从1到8行以及1到8列等于temp_block，c=1，r=2时，designed_plain_text从9到16行以及1到8列等于temp_block
    end
end
designed_cipher_text = position_encryption(designed_plain_text);%位置加密，返回加密结果
for c=1:s2
    for r = 1:s1
        temp_vector = zeros(64,1);  % 产生一个64行1列的矩阵，矩阵元素全为0
        temp_block = designed_cipher_text((r-1)*8+1:r*8,(c-1)*8+1:c*8); %designed_cipher_text矩阵的其中一个8行8列的分矩阵取出来
        temp_vector = temp_block(:);%将temp_block拉直，变为1列，例如a=[1 2;3 4]，则a（:）= [1;3;2;4]变为4行1列的矩阵
        binStr = dec2bin(0,64); %将0转化为二进制的字符串，然后再进行补0直到二进制位数达到64位，即dec2bin(0,64)='00000...0'
        i = find(temp_vector); %得到temp_vector矩阵中各个数的索引
        binStr(i)='1';%将binStr的0换为1，即binStr='111111...1'
        original_block_address = bin2dec(binStr(44:end));%bin2dec表示将二进制字符串转换为十进制数，将binStr从第44个元素到最后的这21个1再转化为10进制数
         row = mod(original_block_address,s2);%将original_block_address对s2取余
         if ~row %如果original_block_address是2的倍数
             row = s2;
         end
         column = ceil(original_block_address/s2);%original_block_address/s2再向上取整
         temp_attack_block = attack_cipher_img_dct((r-1)*8+1:r*8,(c-1)*8+1:c*8);%取 attack_cipher_img_dct的一个8*8的子矩阵
         attack_block(8*row-7:8*row, column*8-7:8*column) = temp_attack_block; %令attack_block的一个8*8子矩阵等于temp_attack_block
    end
end
[attack_result,n_mat] = non_zero_dct_coef(attack_block);
imshow(n_mat/max(max(n_mat)));%max(max(n_mat))表示获取n_mat中最大的元素
x = toc
end

