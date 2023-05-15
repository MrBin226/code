%% 免疫优化算法在物流配送中心选址中的应用
%% 清空环境
close all
clc
clear

%% 算法基本参数           
sizepop=50;           % 种群规模
overbest=10;          % 记忆库容量
MAXGEN=100;            % 迭代次数
pcross=0.5;           % 交叉概率
pmutation=0.3;        % 变异概率
ps=0.95;              % 多样性评价参数
length=4;             % 配送中心数
M=sizepop+overbest;

%% step1 识别抗原,将种群信息定义为一个结构体
individuals = struct('fitness',zeros(1,M), 'concentration',zeros(1,M),'excellence',zeros(1,M),'chrom',[]);
%% step2 产生初始抗体群
individuals.chrom = popinit(M,length);
trace=[]; %记录每代最个体优适应度和平均适应度

%% 迭代寻优
for iii=1:MAXGEN

     %% step3 抗体群多样性评价
     for i=1:M
         individuals.fitness(i) = fitness(individuals.chrom(i,:));      % 抗体与抗原亲和度(适应度值）计算
         individuals.concentration(i) = concentration(i,M,individuals); % 抗体浓度计算
     end
     % 综合亲和度和浓度评价抗体优秀程度，得出繁殖概率
     individuals.excellence = excellence(individuals,M,ps);
          
     % 记录当代最佳个体和种群平均适应度
     [best,index] = min(individuals.fitness);   % 找出最优适应度 
     bestchrom = individuals.chrom(index,:);    % 找出最优个体
     average = mean(individuals.fitness);       % 计算平均适应度
     trace = [trace;best,average];              % 记录
     
     %% step4 根据excellence，形成父代群，更新记忆库（加入精英保留策略，可由s控制）
     bestindividuals = bestselect(individuals,M,overbest);   % 更新记忆库
     individuals = bestselect(individuals,M,sizepop);        % 形成父代群

     %% step5 选择，交叉，变异操作，再加入记忆库中抗体，产生新种群
     individuals = Select(individuals,sizepop);                                                             % 选择
     individuals.chrom = Cross(pcross,individuals.chrom,sizepop,length);                                    % 交叉
     individuals.chrom = Mutation(pmutation,individuals.chrom,sizepop,length);   % 变异
     individuals = incorporate(individuals,sizepop,bestindividuals,overbest);                               % 加入记忆库中抗体      

end

%% 画出免疫算法收敛曲线
figure(1)
plot(trace(:,1));
hold on
plot(trace(:,2),'--');
legend('最优适应度值','平均适应度值')
title('免疫算法收敛曲线','fontsize',12)
xlabel('迭代次数','fontsize',12)
ylabel('适应度值','fontsize',12)
%输出选址结果
disp(bestchrom);
%输出选址成本
fprintf('最优成本：%f\n',trace(end,1))
[~,cost]=fitness(bestchrom);
disp(cost);
% disp(fit,cost);


% [x,y] = fitness_end(bestchrom);
