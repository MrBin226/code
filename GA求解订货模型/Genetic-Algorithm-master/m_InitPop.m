function pop=m_InitPop(numpop,r_min,r_max,q_min,q_max)
%% 初始化种群
%  输入：numpop--种群大小；
%     [r_min,r_max,q_min,q_max]--初始种群所在的区间
pop=zeros(2,numpop);
%rand是产生一个(0,1)的随机数
pop(1,:)=round(rand(1,numpop)*(r_max-r_min)) + r_min;
pop(2,:)=round(rand(1,numpop)*(q_max-q_min)) + q_min;
    