function [MAPE, X_pre]=GM(X, alpha, flag)

if nargin<3
    flag=0;
end

n = length(X);
X_a = zeros(size(X));
% 计算生成序列
temp = zeros(size(X));
for k=1:n
    if alpha > 1
        tt = alpha - 1;
        for i=1:k
            temp(k)=temp(k)+X(i)/(i^(ceil(tt)-tt));
        end
    else
        for i=1:k
            X_a(k)=X_a(k)+X(i)/(i^(ceil(alpha)-alpha));
        end
    end
end
if alpha > 1
    X_a = cumsum(temp);
end
% 计算矩阵B和Y
b_1 = ([X_a,0] + [0,X_a])/2;
b_2 = X_a - [X_a(2:n),0];
B = b_1(2:n)';
B(:,2)=(1-2*(2:n))/2;
B(:,3)=ones(n-1,1)*-1;
Y = b_2(1:n-1)';

% 计算得到参数a,b,c
temp=inv(B'*B)*B'*Y;
a = temp(1);
b = temp(2);
c = temp(3);

% 计算预测值
for k=1:n
    x_res(k) = (X(1)-b/a+b/(a^2)-c/a)*exp(-a*(k-1))+b*k/a-b/(a^2)+c/a;
end
te1=([x_res,0] - [0,x_res]);
if alpha > 1
    X_pre = k^(ceil(alpha)-alpha).*te1(2:n);
else
    X_pre = k^(1-alpha).*te1(2:n);
end
X_pre = [X(1),X_pre];

if flag==1
    for k=1:25
        x_res(k) = (X(1)-b/a+b/(a^2)-c/a)*exp(-a*(k-1))+b*k/a-b/(a^2)+c/a;
    end
    te1=([x_res,0] - [0,x_res]);
    if alpha > 1
        X_pre = k^(ceil(alpha)-alpha).*te1(2:25);
    else
        X_pre = k^(1-alpha).*te1(2:25);
    end
    X_pre = [X(1),X_pre];
    MAPE=1;
    return
end
MAPE = sum(abs(X_pre-X)./X);








