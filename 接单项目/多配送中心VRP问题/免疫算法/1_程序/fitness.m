function [fit,cost]=fitness(individual)
%计算个体适应度值
%individual    input      个体
%fit           output     适应度值
%配送中心坐标
city_coordinate=[117.4402,41.06758;117.4496,41.06788;117.4793,41.06586;117.4362,41.06269;117.4556,41.06355;117.4800,41.06123;117.4293,41.06169;117.4683,41.06030;117.4566,41.05422;117.4632,41.05210];
%供应商坐标
gongying = [117.4305,41.05568;117.4396,41.04953;117.4503,41.06534;];
%货物量pmutation
Q =[15,7,8,5,16,7,13,8,16,19;6,15,9,11,6,9,12,14,5,5;9,8,13,14,8,14,5,8,9,6];

%配送中心的建设成本
F = [30,30,30,30,30,30,30,30,30,30];
V = 40;
%计算供应商到配送点的距离
for r = 1:3
    for j = 1:length(individual)
        distance(r,j)=cal_distance(gongying(r,:), city_coordinate(individual(j),:)) * 1000;
    end
end

C1 = sum(F(individual));

C2 = 0;
C4 = 0;
Chs1 = 0;
for r=1:3
    for i=1:4
        C2 = C2 +10*distance(r,i)*Q(r,individual(i));       %运输成本
        C4 = C4 +15*distance(r,i)*Q(r,individual(i));      %制冷成本
        Chs1 = Chs1 + 48 * Q(r, individual(i)) *(1-exp(-0.03 * distance(r,i) / V));
        %货损成本
    end
end

fit = C1 + C2 + C4 + Chs1;
cost = [C1,C2,C4,Chs1];
end
