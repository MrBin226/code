function [dist,origin_dis] = cal_distance(coordinate,origin_coordinate,a,b,c,d)
num=size(coordinate,1);
dist=zeros(num);
origin_dis=zeros(1,num);
for i=1:num-1
    for j=i+1:num
        d1=abs(coordinate(i,1)-coordinate(j,1))*a;
        d2=abs(coordinate(i,2)-coordinate(j,2))*(b+2*c);
        if coordinate(i,1)==coordinate(j,1)
            if coordinate(i,2)==coordinate(j,2)
                d3=abs(floor((coordinate(i,3)+1)/2)-floor((coordinate(j,3)+1)/2))*d;
            else
                d3=min((7-floor((coordinate(i,3)+1)/2)-floor((coordinate(j,3)+1)/2))*d,(floor((coordinate(i,3)+1)/2)+floor((coordinate(j,3)+1)/2)-2)*d);
            end
        else
            d3=abs(floor((coordinate(i,3)+1)/2)-floor((coordinate(j,3)+1)/2))*d;
        end
        dist(i,j)=d1+d2+d3;
        dist(j,i)=d1+d2+d3;
    end
end
for j=1:num
    d1=abs(origin_coordinate(1)-coordinate(j,1))*a;
    d2=abs(origin_coordinate(2)-coordinate(j,2))*(b+2*c);
    if origin_coordinate(1)==coordinate(j,1)
        if origin_coordinate(2)==coordinate(j,2)
            d3=abs(floor((origin_coordinate(3)+1)/2)-floor((coordinate(j,3)+1)/2))*d;
        else
            d3=min((7-floor((origin_coordinate(3)+1)/2)-floor((coordinate(j,3)+1)/2))*d,(floor((origin_coordinate(3)+1)/2)+floor((coordinate(j,3)+1)/2)-2)*d);
        end
    else
        d3=abs(floor((origin_coordinate(3)+1)/2)-floor((coordinate(j,3)+1)/2))*d;
    end
    origin_dis(j)=d1+d2+d3;
end

end

