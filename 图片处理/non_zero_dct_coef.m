function  [dst,n_mat] = non_zero_dct_coef(dct_coef)
src=imread('lena.jpg');%��ȡͼƬlena.jpg
% dct_coef=imread('lena_cipher.jpg');%��ȡlena_cipher.jpg
r1 = 11;
r2 = 39;
s = size(dct_coef);%��ȡdct_coef������������
dst = zeros(s);%����һ����dct_coef��������ͬ�ľ������о����Ԫ��ȫΪ0
temp = zeros(8);%����һ��8*8,ȫΪ0�ľ���
quant_table = [16 11 10 16 24 40 51 61 ; 
    12 12 14 19 26 58 60 55 ; 
     14 13 16 24 40 57 69 56 ; 
     14 17 22 29 51 87 80 62 ; 
     18 22 37 56 68 109 103 77;
     24 35 55 64 81 104 113 92; 
     49 64 78 87 103 121 120 101; 
     72 92 95 98 112 100 103 99];
dct_quant_src=quant_DCT(src,quant_table);%����quant_DCT����
% dst_count_src=non_zero_dct_coef(dct_quant_src); %����ִ�е��⣬���ϵĵ���non_zero_dct_coef��������Զ�޷����¼���ִ��
% imshow(dst_count_src);
n_mat = zeros(s(1),s(2));%����һ��s(1)��s(2)�е�ȫΪ0�ľ���
for i=1:8:s(1)
    for j=1:8:s(2)
        temp = dct_quant_src(i:i+7,j:j+7);% ��ȡ dct_coef��һ��8*8���Ӿ���
        temp_dst = zeros(8); %����һ��8*8��ȫΪ0�ľ���
        n = length(find(temp)); %find(temp)��ȡtempȫ��Ԫ�ص�������length(find(temp))��ʾ����������
        dst(i:i+7,j:j+7) = temp_dst; %��dst��һ��8*8���Ӿ������temp_dst
        n_mat(i:i+7,j:j+7)=n*ones(8); 
        %ones(8)����һ��8*8��ȫΪ1�ľ���
        %n*ones(8)�õ�һ��8*8ȫΪn�ľ���
        %��n_mat��һ��8*8���Ӿ������һ��8*8ȫΪn�ľ���
    end
end
