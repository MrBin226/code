clc;
clear;
flag = 0;% flag=1表示自动分组，flag=0表示指定哪些表
group_sheet = {'a0000-001','a0000-010';'a0000-019','a0000-028'};%指定的表
if flag
    [~,sheet_names,~] = xlsfinfo('Diam_20-100-2.xlsx');%获取全部的sheet名称
    %含有sheet1的表名，去掉,如果不含sheet1的表名下面一行可以注释掉
    sheet_names=sheet_names(2:end);
    group_num = floor(length(sheet_names) / 2);%共有group_num组
    write_result = {' ', 'x1', 'y1',' ', 'x2', 'y2'};%存储输出到excel表格的数据
    for ss = 1:group_num
        data_1 = xlsread('Diam_20-100-2.xlsx',sheet_names{2*ss-1});% 读取数据
        x_y_1 = data_1(:,[1,3,4]);% 获取x1,y1
        [m,~] = find(isnan(x_y_1));% 获取读取的空值行
        x_y_1(m,:) = [];% 去除空行
        data_2 = xlsread('Diam_20-100-2.xlsx',sheet_names{2*ss});% 读取数据
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
                if t1<=0.06 && t1>=0.04 && t2<=0.2 && t2>0.16
        %         if t1<=1 && t1>0 && t2<=1 && t2>0
                    filter_1 = [filter_1, i];% 存储该行编号
                    filter_2 = [filter_2, j];
                    result = [result;[x_y_1(i,:),x_y_2(j,:)]];
                end
            end
        end
        % 将数据存储到excel
        if ~isempty(result)
            st = {};
            for rr = 1:size(result,2)-2
                st = [st,' '];
            end
            write_result=[write_result;[sheet_names{2*ss-1},sheet_names{2*ss},st];num2cell(result)];
        end
    end
    data_cell_1 = write_result(:,1:3);
    data_cell_2 = write_result(:,4:6);
    [l1,~] = size(write_result);
    xlswrite('execute_data.xlsx',data_cell_1,['A1',':C',num2str(l1)]);
    xlswrite('execute_data.xlsx',data_cell_2,['G1',':I',num2str(l1)]);
else
    write_result={' ', 'x1', 'y1',' ', 'x2', 'y2'};%存储输出到excel表格的数据
    for ss = 1:size(group_sheet,1)
        data_1 = xlsread('Diam_20-100-2.xlsx',group_sheet{ss,1});% 读取数据
        x_y_1 = data_1(:,[1,3,4]);% 获取x1,y1
        [m,~] = find(isnan(x_y_1));% 获取读取的空值行
        x_y_1(m,:) = [];% 去除空行
        data_2 = xlsread('Diam_20-100-2.xlsx',group_sheet{ss,2});% 读取数据
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
                if t1<=0.06 && t1>=0.04 && t2<=0.2 && t2>0.16
        %         if t1<=1 && t1>0 && t2<=1 && t2>0
                    filter_1 = [filter_1, i];% 存储该行编号
                    filter_2 = [filter_2, j];
                    result = [result;[x_y_1(i,:),x_y_2(j,:)]];
                end
            end
        end
        % 将数据存储到excel
        if ~isempty(result)
            st = {};
            for rr = 1:size(result,2)-2
                st = [st,' '];
            end
            write_result=[write_result;[group_sheet{ss,1},group_sheet{ss,2},st];num2cell(result)];
        end
    end
    data_cell_1 = write_result(:,1:3);
    data_cell_2 = write_result(:,4:6);
    [l1,~] = size(write_result);
    xlswrite('execute_data.xlsx',data_cell_1,['A1',':C',num2str(l1)]);
    xlswrite('execute_data.xlsx',data_cell_2,['G1',':I',num2str(l1)]);
end



