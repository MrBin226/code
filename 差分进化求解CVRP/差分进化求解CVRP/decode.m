%
%      @���ߣ�����
%      @΢�Ź��ںţ��Ż��㷨������
%���������Ϊ·��
function result =  decode(chrom)
result=cell(1,1);
chrom(diff(chrom)==0)=[];
position=find(chrom==0);
count=0;
if length(position)==1
    
    if position(1)~=1
        count=count+1;
        result{count}=chrom(1:position(1)-1);
    end
else
    for i=1:length(position)-1
        count=count+1;
        if i==1
            if position(i)~=1
                result{count}=chrom(1:position(i)-1);
                count=count+1;
                result{count}=chrom(position(i)+1:position(i+1)-1);
            else
                result{count}=chrom(position(i)+1:position(i+1)-1);
            end
        else
            result{count}=chrom(position(i)+1:position(i+1)-1);
        end
    end
end

if position(end)~=length(chrom)
    count=count+1;
    result{count}=chrom(position(end)+1:end);
end
end