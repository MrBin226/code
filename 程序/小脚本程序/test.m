clc;
clear all;
file = dir(fullfile('C:\Users\MrBin\Desktop\2016年发布的新数据','*.xlsb'));
% mkdir('data');
for k=1:length(file)
    data = xlsread([file(k).folder,'\',file(k).name]);
    A = data(1:2408,1:2408)./data(end,1:2408);
    A(isnan(A)) = 0;
    Y = sum(data(1:2408,2465:end-1),2);
    E_s = data(1:2408,end);
    [m,~] = size(A);
    s = eye(m)-A;
    B = inv(s);
    v_s = 1 - sum(A,1);
    V = zeros(m);
    E = zeros(m);
    for i = 1:m
        V(i,i) = v_s(i);
        E(i,i) = E_s(i);
    end
    VBE = V * B * E;
    IV = sum(VBE,2)-diag(VBE);
    FV = sum(VBE,1)-diag(VBE)';
    DV = diag(diag(VBE));
    result_1 = DV ./ E;
    result_1(result_1 == Inf) = 0;
    result_1(isnan(result_1)) = 0;
    r1 = IV./E;
    r1(r1==inf)=0;
    r1(isnan(r1))=0;
    r2 = FV./E;
    r2(r2==inf)=0;
    r2(isnan(r2))=0;
    result_2 = log(1 + r1) - log(1 + r2);
    result_3_s = diag(result_1(397:415,397:415));
    result_4_s = diag(result_2(397:415,397:415));
    result_3 = zeros(length(result_3_s));
    result_4 = zeros(length(result_4_s));
    for i = 1:length(result_3_s)
        result_3(i,i) = result_3_s(i);
        result_4(i,i) = result_4_s(i);
    end
%     f = ['data/',num2str(k+1999)];
%     mkdir(f);
%     xlswrite([f,'\result_1.xlsx'],result_1);
%     xlswrite([f,'\result_2.xlsx'],result_2);
%     xlswrite([f,'\result_3.xlsx'],result_3);
%     xlswrite([f,'\result_4.xlsx'],result_4);
    disp(k);
end

