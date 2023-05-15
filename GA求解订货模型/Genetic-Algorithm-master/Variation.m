%% ����
%��   �룺
%           pop              ��Ⱥ
%           VARIATIONRATE    ������
%��   ����
%           pop              ��������Ⱥ
% ���õ������ķ�ʽ
%% 
function kidsPop = Variation(kidsPop,VARIATIONRATE,LENGTH)
for n=1:size(kidsPop,2)
    if rand<VARIATIONRATE
        temp = kidsPop{n};
        %�ҵ�����λ��
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