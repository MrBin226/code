function dom=Dominates(x,y)   %�ж��Ƿ�Ϊ֧���

    if isstruct(x)  %�ж�x�Ƿ�Ϊ�ṹ���飬�����Ϊ1����Ϊ0
        x=x.Cost;
    end

    if isstruct(y)
        y=y.Cost;
    end
    x(2)=20-x(2);
    y(2)=20-y(2);
    dom=all(x>=y) && any(x>y);

end

