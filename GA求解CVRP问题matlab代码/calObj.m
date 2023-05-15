%% 计算种群的目标函数值
%输入：Chrom               种群
%输入：cusnum              顾客数目
%输入：cap                 最大载重量
%输入：demands             需求量
%输入：dist                距离矩阵，满足三角关系，暂用距离表示花费c[i][j]=dist[i][j]
%输出：ObjV                每个个体的目标函数值，定义为车辆使用数目*10000+车辆行驶总距离
function ObjV=calObj(Chrom,cusnum,cap,demands,dist,alpha)
NIND=size(Chrom,1);                         %种群数目
ObjV=zeros(NIND,1);                         %储存每个个体函数值
for i=1:NIND
    VC=decode(Chrom(i,:),cusnum,cap,demands,dist);
    costF=costFuction(VC,dist,demands,cap,alpha);
    ObjV(i)=costF;
end
end