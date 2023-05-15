function binPop=m_Coding(pop,pop_length,r_min,r_max,q_min,q_max)
%% 二进制编码（生成染色体）
% 输入：pop--种群
%      pop_length--编码长度
%      r_min,q_min--r和Q的最小值

%将十进制数减去最小值，因为一个染色体可以取到0，所以减去最小值，便于编码
pop(1,:) = round((2^pop_length(1)-1)*(pop(1,:)-r_min)/(r_max-r_min));
pop(2,:) = round((2^pop_length(2)-1)*(pop(2,:)-q_min)/(q_max-q_min));

for n=1:size(pop,2) %列循环
    for k=1:size(pop,1) %行循环
        dec2binpop{k,n}=dec2bin(pop(k,n));%dec2bin的输出为字符向量；
                                          %dec2binpop是cell数组
        lengthpop=length(dec2binpop{k,n});
        for s=1:pop_length(k)-lengthpop %补零
            dec2binpop{k,n}=['0' dec2binpop{k,n}];
        end
    end
    s=[];
    %将r和Q的格雷码组合在一起，例如r=10001,Q=0011,则组合后为100010011
    for d=1:size(pop,1)
        s=[s,bin2gray(dec2binpop{d,n})];
    end

    binPop{n}=s;
end

    