function dom=Dominates(x,y)   %判断是否为支配解

    if isstruct(x)  %判断x是否为结构数组，如果真为1，假为0
        x=x.Cost;
    end

    if isstruct(y)
        y=y.Cost;
    end
    x(2)=20-x(2);
    y(2)=20-y(2);
    dom=all(x>=y) && any(x>y);

end

