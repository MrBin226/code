clear all
clc
tic;
warning('off');
drawing_flag = 1;
p_energy_max=200;
q_energy_max=150;
% device=[180.43,120.06;80,26.29;100,32.87;160,52.59];%各设备的有功出力和无功出力,第一个故障
device=[180.43,120.06;100,32.87;100,48.43;160,52.59];%各设备的有功出力和无功出力,第一个故障
charge_seq=[1,2,3,4,5,6,7];%负荷序列
interrupt_charge=[3,4,5,6,7];%可断负荷
c=[3,2,2,1,1];%可断负荷的赔偿价格
charge=[-100,-32.87;-80,-38.75;-80,-38.75;-60,-19.72;-100,-32.87;-60,-19.72;-130,-62.96];%各负荷的有功出力和无功出力
P_max=sum(device(:,1))+sum(charge(setdiff(charge_seq,interrupt_charge),1));
Q_max=sum(device(:,2))+sum(charge(setdiff(charge_seq,interrupt_charge),2));
weight_value=charge(interrupt_charge,:)*-1;

[max_value, decision_result] = dynamic_program([weight_value(:,1) weight_value(:,2)*100], [P_max,Q_max*100],c); %乘100是变为整数，便于动态规划计算
con_charge = charge(setdiff(charge_seq,interrupt_charge(decision_result==0)),:);%连接的负荷的有功出力和无功出力
S_source=[p_energy_max,q_energy_max;device(2:end,:)];%微网中所有微源发出的复功率
%存放初始开关集(环网编码策略)
population1=[1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,0];
%确定故障支路
bb=[24];
nVar=36;%变量个数
fobj=@cal_fitvalue;
% Lower bound and upper bound   %下限和上限
lb=0; %下限  
ub=1; %上限
GreyWolves_num=50; %狼的个数
MaxIt=100; 
Archive_size=10; 
VarSize=[1 nVar];  
alpha=0.1; 
nGrid=10 ; 
beta=4;   
gamma=2;    

%%Initialization  初始化
GreyWolves=CreateEmptyParticle(GreyWolves_num);
Grey = initialization(GreyWolves_num ,bb);

for i=1:GreyWolves_num    %狼的个数
    GreyWolves(i).Velocity=0;
    GreyWolves(i).Position=Grey(i,:);   %赋予每头狼初始值
    GreyWolves(i).Cost=fobj(GreyWolves(i).Position,con_charge,S_source,bb);    %求出现有的目标值
    if GreyWolves(i).Cost(1)==0
        GreyWolves(i).Cost(2)=GreyWolves(i).Cost(2)+10;
    end
    GreyWolves(i).Best.Position=GreyWolves(i).Position;   %把每个初始解假设为最优解
    GreyWolves(i).Best.Cost=GreyWolves(i).Cost;           %把目标值假设为最优解
end

GreyWolves=DetermineDomination(GreyWolves);

Archive=GetNonDominatedParticles(GreyWolves);

Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alpha);

for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end
%移位概率
pc = 0.7;
%变异概率
pm = 0.1;
%% 主循环

for it=1:MaxIt       %循环至最大迭代次数
    a=2-it*((2)/MaxIt);   %攻击行为  a值大，促进全局搜索  a值小，进行局部搜索
    for i=1:GreyWolves_num   %循环至狼的最大个数
        
        clear rep2 
        clear rep3
        
        Delta=SelectLeader(Archive,beta);
        Beta=SelectLeader(Archive,beta);
        Alpha=SelectLeader(Archive,beta);
        
        if size(Archive,1)>1
            counter=0;
            for newi=1:size(Archive,1)
                if sum(Delta.Position~=Archive(newi).Position)~=0
                    counter=counter+1;
                    rep2(counter,1)=Archive(newi);
                end
            end
            if exist('rep2')
                Beta=SelectLeader(rep2,beta);
            end
        end
        
        if size(Archive,1)>2
            counter=0;
            if exist('rep2')
                for newi=1:size(rep2,1)
                    if sum(Beta.Position~=rep2(newi).Position)~=0
                        counter=counter+1;
                        rep3(counter,1)=rep2(newi);  
                    end
                end
            end
            if exist('rep3')
                Alpha=SelectLeader(rep3,beta);
            end
        end
        

        c=2.*rand(1, nVar);
        D=abs(c.*Delta.Position-GreyWolves(i).Position);
        A=2.*a.*rand(1, nVar)-a;
        X1=Delta.Position-A.*abs(D);
        
        c=2.*rand(1, nVar);
        D=abs(c.*Beta.Position-GreyWolves(i).Position);
        A=2.*a.*rand()-a;
        X2=Beta.Position-A.*abs(D);
        
        c=2.*rand(1, nVar);
        D=abs(c.*Alpha.Position-GreyWolves(i).Position);
        A=2.*a.*rand()-a;
        X3=Alpha.Position-A.*abs(D);

        tt=1./(1+exp(-5*((X1+X2+X3)./3)));
        temp=zeros(1,nVar);
        temp(tt>=rand())=1;
        GreyWolves(i).Position=correct_sol(temp,bb);
        
        GreyWolves(i).Position=min(max(GreyWolves(i).Position,lb),ub); %查看参数是否在范围内
        
%         GreyWolves(i).Cost=fobj(GreyWolves(i).Position);
    end
    newpop = cat(1,GreyWolves.Position);
    newpop = moveposition(newpop,pc,bb);
    newpop = mutation(newpop,pm,bb);
    for i=1:GreyWolves_num    %狼的个数
        GreyWolves(i).Position=newpop(i,:);   %赋予每头狼初始值
        GreyWolves(i).Cost=fobj(GreyWolves(i).Position,con_charge,S_source,bb);    %求出现有的目标值
        if GreyWolves(i).Cost(1)==0
            GreyWolves(i).Cost(2)=GreyWolves(i).Cost(2)+10;
        end
    end
    
    GreyWolves=DetermineDomination(GreyWolves);
    non_dominated_wolves=GetNonDominatedParticles(GreyWolves);
    
    Archive=[Archive
        non_dominated_wolves];
    
    Archive=DetermineDomination(Archive);
    Archive=GetNonDominatedParticles(Archive);
    
    for i=1:numel(Archive)
        [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end
    
    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gamma);
        
        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,alpha);
        
    end
    
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    
    costs=GetCosts(GreyWolves);        %所有的解 
    Archive_costs=GetCosts(Archive);   %所有的非支配解
    
    if drawing_flag==1
        hold off
        plot(costs(1,:),costs(2,:),'k.');
        hold on
        plot(Archive_costs(1,:),Archive_costs(2,:),'rd');
        legend('Grey wolves','Non-dominated solutions');
        drawnow    %刷新屏幕
    end
    
end
disp('帕累托解如下：');
for i=1:length(Archive)
    pop(i,:)=Archive(i).Position;
end
disp('断开的可断负荷为：');
disp(interrupt_charge(decision_result==0));
pop=unique(pop,'rows');
% obj_value=fobj(pop,con_charge,S_source,bb);
for i=1:size(pop,1)
    fprintf('第%d个解(网损：%f，操作次数：%d)\n',i,powerflow(transform(pop(i,:))),sum(xor(pop(i,:),population1))-1);
    %输出具体操作开关
    [openkg,closekg] = judge_kg(pop(i,:),bb); %求出最优拓扑下需要关断和闭合的开关
    fprintf('具体操作开关:');
    fprintf('（打开）');
    for j=1:length(openkg)
        fprintf('%d ',openkg(j));
    end
    fprintf('（关闭）');
    for j=1:length(closekg)
        fprintf('%d ',closekg(j));
    end
    fprintf('\n');
    disp(pop(i,:));
    
end
toc;
