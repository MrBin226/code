
%% 解码
function [VC,NV,TD,violate_num,violate_cus]=decode(chrom,cusnum,cap,demands,a,b,L,s,dist,len)
violate_num=0;                                      %违反约束路径数目
violate_cus=0;                                      %违反约束顾客数目
VC=cell(cusnum,1);                                  %每辆车所经过的顾客
count=1;                                            %车辆计数器，表示当前车辆使用数目
location0=find(chrom>cusnum);                       %找出个体中配送中心的位置
for i=1:length(location0)
    if i==1                                         %第1个配送中心的位置
        route=chrom(1:location0(i));                %提取两个配送中心之间的路径
        route(route==chrom(location0(i)))=[];       %删除路径中配送中心序号
    else
        route=chrom(location0(i-1):location0(i));   %提取两个配送中心之间的路径
        route(route==chrom(location0(i-1)))=[];     %删除路径中配送中心序号
        route(route==chrom(location0(i)))=[];       %删除路径中配送中心序号
    end
    VC{count}=route;                                %更新配送方案
    count=count+1;                                  %车辆使用数目
end
route=chrom(location0(end):end);                    %最后一条路径       
route(route==chrom(location0(end)))=[];             %删除路径中配送中心序号
VC{count}=route;                                    %更新配送方案
[VC,NV]=deal_vehicles_customer(VC);                 %将VC中空的数组移除
for j=1:NV
    route=cell(1,1);                                %开辟临时元胞数组变量route，存储preroute
    route{1}=VC{j};
    flag=Judge(route,cap,demands,len,dist);     %判断当前方案是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
    if flag==0
        violate_cus=violate_cus+length(route{1});   %如果这条路径不满足约束，则违反约束顾客数目加该条路径顾客数目
        violate_num=violate_num+1;                  %如果这条路径不满足约束，则违反约束路径数目加1
    end
end
TD=travel_distance(VC,dist);                        %该方案车辆行驶总距离
end

