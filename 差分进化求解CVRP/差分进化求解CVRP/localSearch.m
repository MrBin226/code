%
%      @���ߣ�����
%      @΢�Ź��ںţ��Ż��㷨������
function result = localSearch(chrom,cusnum,dist)
%ѡȡһ�����ҵ����ŵ�λ�ò���
removeCus=randi(cusnum);
tempChrom=chrom;
tempChrom(tempChrom==removeCus)=[];
min=inf;
minChrom=[];
for i =1:length(chrom)
    tempChrom2=tempChrom;
    if i==1
        tempChrom2=[removeCus tempChrom2];
        if min>route_length(tempChrom2,dist)
            minChrom=tempChrom2;
            min=route_length(tempChrom2,dist);
        end
    elseif i==length(chrom)
        tempChrom2=[tempChrom2 removeCus];
        if min>route_length(tempChrom2,dist)
            minChrom=tempChrom2;
            min=route_length(tempChrom2,dist);
        end
    else
        tempChrom2=[tempChrom2(1:i-1) removeCus tempChrom2(i:end)];
        if min>route_length(tempChrom2,dist)
            minChrom=tempChrom2;
            min=route_length(tempChrom2,dist);
        end
    end
end
result=minChrom;
end