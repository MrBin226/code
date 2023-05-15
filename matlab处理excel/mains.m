clc;
clear;
close;
data_1 = xlsread('result1.xlsx','829');% 读取数据
x_y_1 = data_1(:,[1,3,4]);% 获取x1,y1
[m,~] = find(isnan(x_y_1));% 获取读取的空值行
x_y_1(m,:) = [];% 去除空行
data_2 = xlsread('result1.xlsx','836');% 读取数据
x_y_2 = data_2(:,[1,3,4]);% 获取x1,y1
[r1,~] = size(x_y_1);% 获取行数
[r2,~] = size(x_y_2);
result=[];% 存储结果
filter_1 = [];%存储已分配的x1，y1的行编号
filter_2 = [];%存储已分配的x2，y2的行编号
for i = 1:r1
    for j = 1:r2
        if sum(ismember(filter_2,j)) % 如果该行已经匹配过，跳过
            continue
        end
        if sum(ismember(filter_1,i))
            break
        end
        t1 = x_y_2(j,2) - x_y_1(i,2);% x2-x1
        t2 = x_y_2(j,3) - x_y_1(i,3);% y2-y1
        if t1<=-0.005 && t1>=-0.015 && t2<=0.009 && t2>0.004
%         if t1<=1 && t1>0 && t2<=1 && t2>0
            filter_1 = [filter_1, i];% 存储该行编号
            filter_2 = [filter_2, j];
            result = [result;[x_y_1(i,:),x_y_2(j,:)]];
        end
    end
end
% 将数据存储到excel
result1 = result(:,1:3);
result2 = result(:,4:6);
data_cell_1 = num2cell(result1);
data_cell_2 = num2cell(result2);
[l1,~] = size(result);
xlswrite('data.xlsx',[{' ', 'x1', 'y1'};data_cell_1],['A1',':C',num2str(l1+1)]);
xlswrite('data.xlsx',[{' ', 'x2', 'y2'};data_cell_2],['G1',':I',num2str(l1+1)]);



