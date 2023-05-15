function dis = cal_distance(x, y)

D2R =@(theta) theta*pi/180;
R = 6378.137;
x = D2R(x);

y = D2R(y);

DeltaS = acos(cos(x(2))*cos(y(2))*cos(x(1)-y(1))+sin(x(2))*sin(y(2)));

dis = R*DeltaS;


end

