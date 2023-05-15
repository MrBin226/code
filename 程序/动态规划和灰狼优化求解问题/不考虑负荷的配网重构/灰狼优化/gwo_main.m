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
charge=[-100,-32.87;-80,-38.75;-80,-38.75;-60,-19.72;-100,-32.87;-60,-19.72;-130,-62.96];%各负荷的有功出力和无功出力
P_max=sum(device(:,1))+sum(charge(setdiff(charge_seq,interrupt_charge),1));
Q_max=sum(device(:,2))+sum(charge(setdiff(charge_seq,interrupt_charge),2));

con_charge = charge;%连接的负荷的有功出力和无功出力
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
GreyWolves_num=25; %狼的个数
MaxIt=50;   


[Alpha_score,Alpha_pos,Convergence_curve]=GWO(GreyWolves_num,MaxIt,lb,ub,nVar,fobj,con_charge,S_source,bb);

figure()
plot(1:MaxIt,Convergence_curve);
xlabel('迭代次数')
ylabel('目标函数')
disp('搜索到的最优解如下：');
disp(['目标函数值为：' num2str(Alpha_score)]);
fprintf('(网损：%f，操作次数：%d)\n',powerflow(transform(Alpha_pos)),sum(xor(Alpha_pos,population1))-1);
%输出具体操作开关
[openkg,closekg] = judge_kg(Alpha_pos,bb); %求出最优拓扑下需要关断和闭合的开关
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
disp(Alpha_pos);
toc;
