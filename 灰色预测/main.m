clc;
clear all;
close all;
x0 = [0.11397,0.05996,0.08891,0.07247,0.06350,0.08141,0.06035,0.05990,0.04517,0.02871,0.02728,0.01788];
n = length(x0);
% 做级比检验
lamda = x0(1:n-1)./x0(2:n);
range = minmax(lamda);
ccc=0;
if range(1,1) < exp(-(2/(n+1))) || range(1,2) > exp(2/(n+1))
    disp('级比检验不符合要求,进行平移转换');
    while(1)
        x0 = x0 + 1;
        ccc=ccc+1;
        Ratio = zeros(1 , n- 1);
        for i = 1:n - 1
            Ratio(i) = x0(i) / x0(i+1);
        end
        if( exp(-2 / (n+1)) < min(Ratio) && max(Ratio) < exp(2 / (n+1)) )
            disp('平移转换系数c=')
            disp(ccc);
            break;
        end
    end
else
    disp('满足条件，可以建模');
end
y=x0;
n=length(y);
yy=ones(n,1);
yy(1)=y(1);
for i=2:n
    yy(i)=yy(i-1)+y(i);
end
disp('经过平移转换后的序列：')
disp(y)
disp('一次累加序列：')
disp(cumsum(y))
B=ones(n-1,2);
for i=1:(n-1)
    B(i,1)=-(yy(i)+yy(i+1))/2;
    B(i,2)=1;
end
disp('数据矩阵B：')
disp(B)
BT=B';
for j=1:n-1
    YN(j)=y(j+1);
end
YN=YN';
A=inv(BT*B)*BT*YN;
a=A(1);
u=A(2);
t=u/a;
disp('a：');
disp(a)
disp('b：');
disp(u);

% 预测步长
predict_step=2;

i=1:n+predict_step;
yys(i+1)=(y(1)-t).*exp(-a.*i)+t;
yys(1)=y(1);
for j=n+predict_step:-1:2
    ys(j)=yys(j)-yys(j-1);
end
forecast=[x0(1), ys(2:n)];

forecast=forecast-ccc;
x0=x0-ccc;


% 计算灰色残差
epsilon = x0 - forecast;
disp('残差：')
disp(epsilon)

% 计算关联度
r = sum((min(min(abs(epsilon)))+0.5*max(max(abs(epsilon))))./(abs(epsilon)+0.5*max(max(abs(epsilon)))))/n;
disp('关联度：')
disp(r)

disp('预测数据：')
disp(ys(n+1:n+predict_step)-ccc)

res=[x0',forecast',epsilon'];

figure(1)
plot((1:n),x0,'ro-','markersize',5);
hold on
plot((1:n),forecast,'b*-','linewidth',1);
grid on;
axis tight;
legend('原始数列','灰色模型数列','Location','Best');
xlabel('月份');