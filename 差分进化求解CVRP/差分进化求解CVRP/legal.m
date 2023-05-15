%
%      @作者：挽月
%      @微信公众号：优化算法交流地
function result = legal(chrom,carnum)
%变异后合法化过程
    constChrom=chrom;
    position=find(chrom==0);
    if length(position)>carnum
        position=position(1:carnum);
    end
    chrom(position)=[];
    [~,I]=sort(chrom);
    [~,result]=sort(I);
    
    point=0;
    count=0;
    while 1
        point=point+1;
        if constChrom(point)==0
            count=count+1;
            if point==1
                result=[0 result];
            elseif point==length(constChrom)
                result=[result 0];
            else
                result=[result(1:point-1) 0 result(point:end)];
            end
        end
        if point==length(constChrom)||count==length(position)
            break;
        end
    end
end