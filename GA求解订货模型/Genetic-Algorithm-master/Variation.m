%% 变异
%输   入：
%           pop              种群
%           VARIATIONRATE    变异率
%输   出：
%           pop              变异后的种群
% 采用单点变异的方式
%% 
function kidsPop = Variation(kidsPop,VARIATIONRATE,LENGTH)
for n=1:size(kidsPop,2)
    if rand<VARIATIONRATE
        temp = kidsPop{n};
        %找到变异位置
%         location = ceil(length(temp)*rand);
        location1 = randperm(LENGTH(1),1);
        location2 = randperm(LENGTH(2),1)+LENGTH(1);
        if location1 > 1
            temp = [temp(1:location1-1) num2str(~str2num(temp(location1)))...
                temp(location1+1:end)];
        else
             temp = [num2str(~str2num(temp(location1)))...
                temp(location1+1:end)];   
        end
        temp = [temp(1:location2-1) num2str(~str2num(temp(location2)))...
            temp(location2+1:end)];
        kidsPop{n} = temp;
    end
end