function [a b] = judge_kg(pop1,bb)
%判断一个种群下需要动作的开关
%openkg表示需要打开的开关
%closekg表示需要闭合的开关
S=transform(pop1);
zhilu=ones(1,37);
for k=1:37             %zhilu中37条支路的状态
    if k==S(1)
       zhilu(k)=0;
    end
    if k==S(2)
       zhilu(k)=0;
    end
    if k==S(3)
       zhilu(k)=0;
    end
    if k==S(4)
       zhilu(k)=0;
    end
    if k==S(5)
       zhilu(k)=0;
    end
end
h=1;
for k=1:32   
    if zhilu(k)==0    %判断打开的支路
       %if k~=bb       %保证不是故障支路
        a(h)=k;
        h=h+1;
      % end
    end
end
if h==1   %判断是否存在不需要打开开关的情况 a=0表示没有要打开的开关
    a=0; 
end
t=1;
for k=33:37
     if zhilu(k)==1    %判断闭合的支路
        b(t)=k;
        t=t+1;
     end
end
if t==1  %判断是否存在不需要打开开关的情况 b=0表示没有要打开的开关
    b=0; 
end
end

