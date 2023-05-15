%计算适应度值
%输入变量：种群
%输出变量：适应度值
function fitvalue = cal_fitvalue(pop,con_charge,S_source,bb,cost)
popsize=size(pop,1);             %有popsize个个体
population1=[1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,0]; %存放初始开关集
for k=1:popsize
    S=transform(pop(k,:));       %将基因二进制转换为具体的开关号
    fitvalue1(k)=powerflow(S);      %计算该状态下的网损
    if fitvalue1(k)<0 || fitvalue1(k)>0.08 || isnan(fitvalue1(k)) %置0，08，排除不可行解
       fitvalue1(k)=0.08;
    else
        flag=[];
        [~,u,~]=powerflow_V(S);
        flag=[flag ~ismember(0,u<=1.05&u>=0.85)];
        [~,p,q,Iresult]=powerflow_S(S);
        Iresult(bb)=[];
         I = abs(Iresult);
        flag=[flag ~ismember(0,I<=1)];
        p(bb)=[];
        q(bb)=[];
        S1 = sum(p)+sum(con_charge(:,1))+sum(S_source(2:end,1));
        S2 = sum(q)+sum(con_charge(:,2))+sum(S_source(2:end,2));
        flag=[flag (S1+S_source(1,1)>=0 && S2+S_source(1,2)>=0)];
        
        if ismember(0,flag)
            fitvalue1(k)=0.08;
        end
    end
    %用0.08减去网损，保证网损越小，适应度值越大；*10是为了保证fitvalue1与fitvaule2接近一个量级上
    fitvalue1(k)=(0.08-fitvalue1(k))*10;
    fitvalue2(k)=sum(xor(pop(k,:),population1))-1; %计算开关操作次数，-1是因为排除故障支路的动作
    fitvalue2(k)=1/fitvalue2(k);%用1除去操作次数，保证操作次数越少，适应度值越大
    fitvalue(k)=0.1*fitvalue1(k)+0.2*fitvalue2(k)+0.7*cost/100; %计算适应度，采用权值转换成单目标
end
end
