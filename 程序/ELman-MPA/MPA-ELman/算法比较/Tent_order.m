function [f] = Tent_order(row,column)
f=zeros(row*column,1);
k0=rand();
a=0.5;
b=0.2;
for i=1:row*column
    if i==1
        f(i)=mod(k0+b-a*sin(2*pi*k0)/(2*pi),1);
    else
        f(i)=mod(f(i-1)+b-a*sin(2*pi*f(i-1))/(2*pi),1);
    end
end
f=reshape(f,[row,column]);
end

