%
%      @作者：挽月
%      @微信公众号：优化算法交流地
%根据交叉概率，判断两个个体是否交叉，如果交叉选择目标函数最小的个体返回
function result = cross(chrom1,chrom2,dist,cr,Demand,MAXLOAD)
p=rand(1);
if p<cr
       [~,n]=size(chrom1);
        while 1
            c1=randi(n);
            c2=randi(n);
            if c1~=c2&&c1+2<c2
                break;
            end
        end
    temp1_1=chrom1(1:c1);
    temp1_2=chrom1(c1+1:c2-1);
    temp1_3=chrom1(c2:end);
    temp2_1=chrom2(1:c1);
    temp2_2=chrom2(c1+1:c2-1);
    temp2_3=chrom2(c2:end);
    l1_1=length(temp1_1);
    l1_2=length(temp1_2);
    l1_3=length(temp1_3);
    l2_1=length(temp2_1);
    l2_2=length(temp2_2);
    l2_3=length(temp2_3);
    temp1=[temp1_3 temp1_1 temp1_2];
    for i=1:l2_2
        index=find(temp1==temp2_2(i));
        if isempty(index)
            continue;
        end
        temp1(index(1))=[];
    end
    chrom1=[temp1(l1_3+1:end) temp2_2 temp1(1:l1_3)];

    temp2=[temp2_3 temp2_1 temp2_2];
    for i=1:l1_2
        index=find(temp2==temp1_2(i));
        if isempty(index)
            continue;
        end
        temp2(index(1))=[];
    end
    chrom2=[temp2(l2_3+1:end) temp1_2 temp2(1:l2_3)];
% chrom1
% chrom2
    if calobj(chrom1,dist,Demand,MAXLOAD)<calobj(chrom2,dist,Demand,MAXLOAD)
        result=chrom1;
    else
        result=chrom2;
    end 
else
    if calobj(chrom1,dist,Demand,MAXLOAD)<calobj(chrom2,dist,Demand,MAXLOAD)
        result=chrom1;
    else
        result=chrom2;
    end 
end
end