function dst =position_encryption(src)
% src=imread('lena.jpg');%读取lena.jpg，得到一个图像矩阵
s = size(src);%获取src的行数和列数,s(1)表示行数，s(2)表示列数
e1 = mod(s(1),8);%mod()是求余函数，mod(s(1),8)表示s(1)对8取余
s1 = floor(s(1)/8);%s(1)/8的结果再向下取整
if e1 %如果s(1)不是8的倍数
    d1 = ones(1,s1+1);%生成一个1行s1+1列的矩阵，矩阵元素全为1
    d1 = 8*d1;%得到一个1行s1+1列的矩阵，矩阵元素全为8
    d1(s1+1) = e1;%令d1的第1行，第s1+1列的元素等于e1
else %如果s(1)是8的倍数
    d1 = ones(1,s1);
    d1 = 8*d1;
end
e2 = mod(s(2),8);%mod(s(2),8)表示s(2)对8取余
s2 = floor(s(2)/8);
if e2 %如果s(2)不是8的倍数
    d2 = ones(1,s2+1);
    d2 = 8*d2;
    d2(s2+1) = e2;
else %如果s(2)是8的倍数
    d2 = ones(1,s2);
    d2 = 8*d2;
end
%调用coupled_logistic_map函数
sequence = coupled_logistic_map([0.062,0.284], length(d1)*length(d2)); % length(d1)*length(d2)表示d1的列数*d2的列数
[y,key] = sort(sequence(2,:));%sort(sequence(2,:))表示对矩阵sequence的第2行进行从小到大排序,y表示排序的结果,key表示排序后的元素在原来向量中的位置
% 例如a=[3,2,1],[b,c]=sort(a); 则b=[1,2,3],c=[3,2,1]，其中c的第一个元素表示b中的第一个元素在a中的位置为3
if(length(s)>2) %如果s中的元素大于2，即表示lena.jpg是一张彩色图片，即三维图像
    s3 = s(3); %获取图片的通道数，即3
    cell_src = mat2cell(src,d1,d2,s3); %表示把src按给定的d1，d2，s3尺度进行分解
    cell_en = cell_src(1:s1,1:s2,:); %获取3个通道中每个通道从1到s1的行以及1到s2的列
else % 否则表示lena.jpg是一张灰度或黑白图片，即二维图像，只有一个通道
    cell_src = mat2cell(src,d1,d2);
    cell_en = cell_src(1:s1,1:s2); 
end
cell_dst = cell_src;
cell_d = cell_en;

cell_d(key) = cell_en; 
%令cell_en数组按照key进行位置排列
%例如a=[10 11;12 13], b=a, c=[2 3 1 4]，则b(c)=a表示a按照c进行排列位置，即b=[11 12;10 13]
    cell_dst(1:s1,1:s2) = cell_d;
dst = cell2mat(cell_dst);%将cell数组转化为矩阵

