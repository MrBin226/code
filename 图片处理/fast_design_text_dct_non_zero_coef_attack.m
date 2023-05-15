function n_mat = fast_design_text_dct_non_zero_coef_attack(attack_cipher_img)
tic; %��¼��ǰʱ�䣬�Ա�Գ�������ʱ��������
attack_cipher_img_dct = quant_DCT(attack_cipher_img);%��attack_cipher_img����DCT�任
imshow(attack_cipher_img_dct);
attack_result = 0*attack_cipher_img_dct;%0�����attack_cipher_img_dct��ÿ��Ԫ����ˣ��õ�һ����attack_cipher_img_dct��������ͬ��ȫ�����
attack_block = attack_result;%attack_block����attack_result
s = size(attack_cipher_img_dct);%�õ�attack_cipher_img_dct�������У�s��1�������У�s��2��������
s1 = floor(s(1)/8);%s(1)/8������ȡ������floor��4.8��=4
s2 = floor(s(2)/8);
ss1 = floor(s1/8);
ss2 = floor(s2/8);
designed_plain_text = 0*attack_cipher_img_dct;%�õ�һ�������attack_cipher_img_dct��������ͬ��ȫ�����
cell_dpt = cell(s1,s2);%����һ��s1�У�s2�е�Ԫ������
%һ��ͼ�����ص������ᳬ��64*2^64��ô�࣬���ֻ��Ҫһ���������ͼ��
r = 1;%8*8����м���
c = 1;%8*8����м���
temp_vector = zeros(64,1);%����һ��64�У�1�е�ȫ�����
temp_block = zeros(8);%����һ������8��0Ԫ�ص�����
for c = 1:s2
    for r = 1:s1
        temp_vector = zeros(64,1);%����һ��64�У�1�е�ȫ�����
        address = r+s2*(c-1);%r+s2*(c-1)
        binStr = dec2bin(address,64);%��addressת��Ϊ���������ַ��������ת���Ķ���������λ��С��64������ǰ�油0������dec2bin(4,4)��4ת��Ϊ������Ϊ100��λ��Ϊ3С��4����0��Ϊ0100
        temp_vector = double(binStr-'0');%���������ַ���binStrת��Ϊ������double('0100'-'0')=[0,1,0,0]
      temp_block = reshape(temp_vector,8,8);%��temp_vector��Ϊ8��8�еľ���
      designed_plain_text((r-1)*8+1:r*8,(c-1)*8+1:c*8) = temp_block; 
      % designed_plain_text���������һ��8��8�еķ־���ȡ�������������temp_block��������c=1��r=1ʱ��designed_plain_text��1��8���Լ�1��8�е���temp_block��c=1��r=2ʱ��designed_plain_text��9��16���Լ�1��8�е���temp_block
    end
end
designed_cipher_text = position_encryption(designed_plain_text);%λ�ü��ܣ����ؼ��ܽ��
for c=1:s2
    for r = 1:s1
        temp_vector = zeros(64,1);  % ����һ��64��1�еľ��󣬾���Ԫ��ȫΪ0
        temp_block = designed_cipher_text((r-1)*8+1:r*8,(c-1)*8+1:c*8); %designed_cipher_text���������һ��8��8�еķ־���ȡ����
        temp_vector = temp_block(:);%��temp_block��ֱ����Ϊ1�У�����a=[1 2;3 4]����a��:��= [1;3;2;4]��Ϊ4��1�еľ���
        binStr = dec2bin(0,64); %��0ת��Ϊ�����Ƶ��ַ�����Ȼ���ٽ��в�0ֱ��������λ���ﵽ64λ����dec2bin(0,64)='00000...0'
        i = find(temp_vector); %�õ�temp_vector�����и�����������
        binStr(i)='1';%��binStr��0��Ϊ1����binStr='111111...1'
        original_block_address = bin2dec(binStr(44:end));%bin2dec��ʾ���������ַ���ת��Ϊʮ����������binStr�ӵ�44��Ԫ�ص�������21��1��ת��Ϊ10������
         row = mod(original_block_address,s2);%��original_block_address��s2ȡ��
         if ~row %���original_block_address��2�ı���
             row = s2;
         end
         column = ceil(original_block_address/s2);%original_block_address/s2������ȡ��
         temp_attack_block = attack_cipher_img_dct((r-1)*8+1:r*8,(c-1)*8+1:c*8);%ȡ attack_cipher_img_dct��һ��8*8���Ӿ���
         attack_block(8*row-7:8*row, column*8-7:8*column) = temp_attack_block; %��attack_block��һ��8*8�Ӿ������temp_attack_block
    end
end
[attack_result,n_mat] = non_zero_dct_coef(attack_block);
imshow(n_mat/max(max(n_mat)));%max(max(n_mat))��ʾ��ȡn_mat������Ԫ��
x = toc
end

