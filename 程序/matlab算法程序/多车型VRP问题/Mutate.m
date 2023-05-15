%% 变异操作
%输入：
%SelCh  被选择的个体
%Pm     变异概率
%输出：
% SelCh 变异后的个体
function [new_pop_x,new_pop_y]=Mutate(new_pop_x,new_pop_y,Pm,demand,vehicle_cap,vehicle_model)
[NSel,L]=size(new_pop_x);
for i=1:NSel
    if rand()<=Pm
        [~,n,~]=decode(new_pop_x(i,:),new_pop_y(i,:),demand,vehicle_cap);
        r=randperm(n,1);
        t=setdiff(1:vehicle_model,new_pop_y(i,r));
        new_pop_y(i,r)=t(randperm(length(t),1));
        R=randperm(L);
        new_pop_x(i,R(1:2))=new_pop_x(i,R(2:-1:1));
    end
end
