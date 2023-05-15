function dst = quant_DCT(src,quant_table)%src是图像像素值矩阵    quant_table是8*8量化表
src=imread('lena.jpg');%读取lena.jpg图像文件，得到图像矩阵
if nargin <2 %如果quant_DCT函数只有一个输入参数，即只给src赋值
quant_table = [8,6,5,8,12,20,26,31;
    6,6,7,10,13,29,30,28;
    7,7,8,12,20,29,35,28;
    7,9,11,15,26,44,40,31;
    9,11,19,28,34,55,52,39;
    12,18,28,32,41,52,57,46;
    25,32,39,44,52,61,60,51;
    36,46,48,49,56,50,52,50];
end
s = size(src);%获取图像的尺寸，含有长和宽（s(1)表示长，s(2)表示宽）
r = ceil(s(1)/8);%图片的长除以8的结果向上取整
c = ceil(s(2)/8);%图片的宽除以8的结果向上取整
src1 = zeros(r*8,c*8);%生成一个和src维度一样大的零矩阵
src1(1:s(1),1:s(2)) = src;%把1到s(1)的行以及1到s(2)的列的部分等于读取的图片矩阵，例如src1(1:64,1:64) = src就是把矩阵的前64行以及前64列等于src
dst = src1;%令dst等于src1
temp88 = zeros(8);%生成一个含有8个元素的行向量，如（0，0，0，0，0，0，0，0）
dst_temp = temp88;%令dst_temp等于temp88
reciprocal_quant_table = 1./quant_table;%quant_table内的每个元素分别被1所除，并把其结果赋给reciprocal_quant_table
D = dctmtx(8);%dctmtx是DCT变换矩阵函数,返回一个8*8的DCT变换矩阵
for i = 1:r %i从1到r每隔一位取一个，即i=1，2，3，...，r
    for j=1:c %j从1到c每隔一位取一个，即j=1，2，3，...，c
        temp88 = src1(i*8-7:i*8,j*8-7:j*8);%把src1矩阵的其中一个8行8列的分矩阵取出来，即假设i=1，j=1时，temp88等于src1从1到8行以及1到8列的分矩阵，i=1，j=2时，temp88等于src1从1到8行以及9到16列的分矩阵
        %D*temp88*D'是矩阵D乘以矩阵temp88再乘以矩阵D的转置，是对temp88实现DCT变换
        %round((D*temp88*D')，其中round函数表示四舍五入函数，把D*temp88*D'得到的结果每个值进行四舍五入
        %round((D*temp88*D').*reciprocal_quant_table表示矩阵round((D*temp88*D')的每一个值都与reciprocal_quant_table对应的值进行相乘
        %例如：a=[1 2;3 4],b=[1 2;3 4]  则a.*b=[1*1 2*2;3*3 4*4]
        dst_temp = round((D*temp88*D').*reciprocal_quant_table);
        % dst(i*8-7:i*8,j*8-7:j*8)与src1(i*8-7:i*8,j*8-7:j*8)取值的原理相同，可见第25行的注释
        dst(i*8-7:i*8,j*8-7:j*8) = dst_temp;
    end
end