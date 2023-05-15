clc;
clear;
close all;
A=imread('小鸭子-原始图.jpg');
thresh=graythresh(A);
A=im2bw(A,thresh);
BW1=edge(A,'canny');
IBW = ~A;
F1 = imfill(IBW,'holes');
SE = ones(3);
F2 = imdilate(F1,SE,'same');
BW3 = bwperim(F2);
[r,c]=size(BW3);
a1=[271,r-423];
b1=[690,r-1119];
p1=(a1+b1)/2;
a2=[315,r-355];
b2=[691,r-1039];
p2=(a2+b2)/2;
k1=-1/((a1(2)-b1(2))/(a1(1)-b1(1)));
k2=-1/((a2(2)-b2(2))/(a2(1)-b2(1)));
b11=p1(2)-k1*p1(1);
b22=p2(2)-k1*p2(1);
x=(b22-b11)/(k1-k2);
y=k1*x+b11;
jie_zhyy31=[x,y];
a2 = (a1(1)-x)*(a1(1)-x)+(a1(2)-y)*(a1(2)-y);
b2 = (b1(1)-x)*(b1(1)-x)+(b1(2)-y)*(b1(2)-y);
c2 = (a1(1)-b1(1))*(a1(1)-b1(1))+(a1(2)-b1(2))*(a1(2)-b1(2));
a = sqrt(a2);
b = sqrt(b2);
c = sqrt(c2);
pos = (a2+b2-c2)/(2*a*b);
angle = acos(pos);
jie_zhyy32 = angle*180/pi;
disp('旋转中心坐标(以左边线为 y 轴，下边线为 x 轴)：');
fprintf('(x,y)=(%.2f,%.2f)\n',x,y);
disp('旋转角度：');
disp(jie_zhyy32);







