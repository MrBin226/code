function sequence = coupled_logistic_map(x, t)%coupled_logistic_map是用来生成置乱8*8小块的置乱序列的，产生的序列是二维的
src=imread('lena.jpg');%读取lena.jpg，得到图像矩阵
x=[0.34,0.75];
s = size(src);%得到src的行数和列数
t=(s(1)*s(2))/64;
x1 = x(1);
x2 = x(2);
mu1 = 2.93;
mu2 = 3.17;
gamma1 = 0.179;
gamma2 = 0.139;
sequence = zeros(2,t);%产生一个2行t列的矩阵，矩阵元素全为0
sequence(1,1) = x1; %sequence矩阵的第1行第1列元素等于x1
sequence(2,1) = x2; %sequence矩阵的第2行第1列元素等于x1
for i=2:t %i从2到t依次取值，i=2，3，4，5，...，t
    % sequence矩阵的第1行第i列元素等于mu1*sequence矩阵的第1行第i-1列元素*（1-sequence矩阵的第1行第i-1列元素）+gamma1*sequence矩阵的第2行第i-1列元素的平分
    % 例如当i=2时，因为sequence(1,1)=x1,sequence(2,1)=x2，此时sequence(1,2)=mu1*x1*(1-x1)+gamma1*(x2)^2
    sequence(1,i) = mu1*sequence(1,i-1)*(1-sequence(1,i-1))+gamma1*sequence(2,i-1)^2;
    % 例如当i=2时，因为sequence(1,1)=x1,sequence(2,1)=x2，此时sequence(2,2)=mu2*x2*(1-x2)+gamma2*(x1)^2+x1*x2
    sequence(2,i) = mu2*sequence(2,i-1)*(1-sequence(2,i-1))+gamma2*(sequence(1,i-1)^2+sequence(1,i-1)*sequence(2,i-1));
end