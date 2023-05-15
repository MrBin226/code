clc;
clear;
flag = 0;% flag=1��ʾ�Զ����飬flag=0��ʾָ����Щ��
group_sheet = {'a0000-001','a0000-010';'a0000-019','a0000-028'};%ָ���ı�
if flag
    [~,sheet_names,~] = xlsfinfo('Diam_20-100-2.xlsx');%��ȡȫ����sheet����
    %����sheet1�ı�����ȥ��,�������sheet1�ı�������һ�п���ע�͵�
    sheet_names=sheet_names(2:end);
    group_num = floor(length(sheet_names) / 2);%����group_num��
    write_result = {' ', 'x1', 'y1',' ', 'x2', 'y2'};%�洢�����excel��������
    for ss = 1:group_num
        data_1 = xlsread('Diam_20-100-2.xlsx',sheet_names{2*ss-1});% ��ȡ����
        x_y_1 = data_1(:,[1,3,4]);% ��ȡx1,y1
        [m,~] = find(isnan(x_y_1));% ��ȡ��ȡ�Ŀ�ֵ��
        x_y_1(m,:) = [];% ȥ������
        data_2 = xlsread('Diam_20-100-2.xlsx',sheet_names{2*ss});% ��ȡ����
        x_y_2 = data_2(:,[1,3,4]);% ��ȡx1,y1
        [r1,~] = size(x_y_1);% ��ȡ����
        [r2,~] = size(x_y_2);
        result=[];% �洢���
        filter_1 = [];%�洢�ѷ����x1��y1���б��
        filter_2 = [];%�洢�ѷ����x2��y2���б��
        for i = 1:r1
            for j = 1:r2
                if sum(ismember(filter_2,j)) % ��������Ѿ�ƥ���������
                    continue
                end
                if sum(ismember(filter_1,i))
                    break
                end
                t1 = x_y_2(j,2) - x_y_1(i,2);% x2-x1
                t2 = x_y_2(j,3) - x_y_1(i,3);% y2-y1
                if t1<=0.06 && t1>=0.04 && t2<=0.2 && t2>0.16
        %         if t1<=1 && t1>0 && t2<=1 && t2>0
                    filter_1 = [filter_1, i];% �洢���б��
                    filter_2 = [filter_2, j];
                    result = [result;[x_y_1(i,:),x_y_2(j,:)]];
                end
            end
        end
        % �����ݴ洢��excel
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
    write_result={' ', 'x1', 'y1',' ', 'x2', 'y2'};%�洢�����excel��������
    for ss = 1:size(group_sheet,1)
        data_1 = xlsread('Diam_20-100-2.xlsx',group_sheet{ss,1});% ��ȡ����
        x_y_1 = data_1(:,[1,3,4]);% ��ȡx1,y1
        [m,~] = find(isnan(x_y_1));% ��ȡ��ȡ�Ŀ�ֵ��
        x_y_1(m,:) = [];% ȥ������
        data_2 = xlsread('Diam_20-100-2.xlsx',group_sheet{ss,2});% ��ȡ����
        x_y_2 = data_2(:,[1,3,4]);% ��ȡx1,y1
        [r1,~] = size(x_y_1);% ��ȡ����
        [r2,~] = size(x_y_2);
        result=[];% �洢���
        filter_1 = [];%�洢�ѷ����x1��y1���б��
        filter_2 = [];%�洢�ѷ����x2��y2���б��
        for i = 1:r1
            for j = 1:r2
                if sum(ismember(filter_2,j)) % ��������Ѿ�ƥ���������
                    continue
                end
                if sum(ismember(filter_1,i))
                    break
                end
                t1 = x_y_2(j,2) - x_y_1(i,2);% x2-x1
                t2 = x_y_2(j,3) - x_y_1(i,3);% y2-y1
                if t1<=0.06 && t1>=0.04 && t2<=0.2 && t2>0.16
        %         if t1<=1 && t1>0 && t2<=1 && t2>0
                    filter_1 = [filter_1, i];% �洢���б��
                    filter_2 = [filter_2, j];
                    result = [result;[x_y_1(i,:),x_y_2(j,:)]];
                end
            end
        end
        % �����ݴ洢��excel
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



