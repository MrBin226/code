%
%      @���ߣ�����
%      @΢�Ź��ںţ��Ż��㷨������
%���ģ��������
%ѡȡ���������ĵ�������룬�����µ������
function result = LargeSearch(chrom,len,cusnum,dist,Demand,MAXLOAD)
dist(dist==0)=inf;
while 1
removeCus=randperm(cusnum,len);
constChrom=chrom;
constChrom(constChrom==0)=[];
temp=chrom;
for i = 1:length(removeCus)
    constChrom(constChrom==removeCus(i))=[];
    temp(temp==removeCus(i))=[];
end
position=[];
for i = 1:length(removeCus)
    mind=inf;
    for j=1:length(constChrom)
        if mind>dist(removeCus(i)+1,constChrom(j)+1)
            position(i)=constChrom(j);
            mind=dist(removeCus(i)+1,constChrom(j)+1);
        end
    end
    constChrom=[constChrom(1:find(constChrom==position(i))-1) removeCus(i) constChrom(find(constChrom==position(i)):end)];
    temp=[temp(1:find(temp==position(i))-1) removeCus(i) temp(find(temp==position(i)):end)];
end

    if test(decode(temp),Demand,MAXLOAD)==1
        break;
    end
end
result=temp;
end