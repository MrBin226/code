%输入：
%a和b为两个待交叉的个体
%输出：
%a和b为交叉后得到的两个个体
function [a1,b1]=OX(a,b)

   num=length(a);
   p1=find(a>0);
   p1=p1(end);
   p2=find(b>0);
   p2=p2(end);
   if p1<p2
       a=a(1:p2);
       b=b(1:p2);
   else
       b=b(1:p1);
       a=a(1:p1);
   end
    ind=[randi([1,floor(length(a)/2)],1),randi([floor(length(a)/2)+1,length(a)],1)];
    a1=b(ind(1):ind(2));
    b1=a(ind(1):ind(2));
    a0=a;
    b0=b;
    l=length(a1);

    for i=1:l
        tm1=find(a0==a1(i));
        tm2=find(b0==b1(i));
        a0(tm1(1))=inf;
        b0(tm2(1))=inf;
    end
    a0(a0==inf)=[];
    b0(b0==inf)=[];

    a1=[a0(1:ind(1)-1) a1 a0(ind(1):end)];
    b1=[b0(1:ind(1)-1) b1 b0(ind(1):end)];
    p=max(p1,p2);
    a1(p+1:num)=0;
    b1(p+1:num)=0;
end