%================================================
% MPSO: A Modified Particle Swarm Optimization Using Adaptive Strategy
% % Authors: Hao Liu, XueWei Zhang, LiangPing Tu
% Journal: Expert System With Applications
% Email: haoliu@ustl.edu.cn,    liuhustl@sina.cn
%================================================

clc;   %Clear Screen
clear; %Clear workspace
global initial_flag;
PopSize = 50;           %No. of particles
Runs = 50;          %No. of runs
tol_err = 1e-8;   %Absolute Error
C0=100;

delete Results\MPSO_Results.txt
diary Results\MPSO_Results.txt
for funNum=[1 3:30]
    [F_Name,Dim,LB,UB,opt_f] =get_fun_info_CEC2017(funNum);
    Max_FEs =5E4;% Dim*1E4;                  %Max. no. of function evaluations
    Max_Iter=ceil(Max_FEs/PopSize);     %T: Max. no. of iteration number
    fprintf('f%d: %s, opt_f=%1.8E, PopSize=%d, Dim=%d, Max_FEs=%d, Max_Iter=%d, Runs=%d\n',funNum, F_Name, opt_f, PopSize, Dim, Max_FEs, Max_Iter, Runs);
    
   MPSO_FEs = zeros(1,Runs);
   MPSO_f = zeros(1,Runs);
   MPSO_TotalTime = zeros(1,Runs);
   MPSO_SR = 0;
   MPSO_Fbest=[];
    %=====Nr times run independently=====
    for r=1:1:Runs
        initial_flag = 0;
        tic; %Reset the timer
        [MPSO_Gbest,MPSO_f(r),MPS_FEs(r),MPSO_Fbest(r,:)] =MPSO(PopSize,Dim, Max_FEs, Max_Iter, funNum, tol_err, LB, UB, opt_f,r);%MPSO (PopSize,Dim, Max_FEs, Max_Iter, funNum, tol_err, LB, UB, opt_f,r);
        if MPSO_f(r)-opt_f <= tol_err  % Only record "Successful" run
           MPSO_SR =MPSO_SR + 1;
%            MPSO _TotalTime(r) = toc;
        end   
       MPSO_TotalTime(r) = toc;
%        [minf, min_index]=min(MPSO _f(r));
%        X_Best=MPSO _Gbest(min_index,:);
    end %r
   MPSO_SR=100*MPSO_SR/Runs;
    %% ===== Output Results =====
    fprintf('MPSO_Mean = %1.8E,MPSO_Std=%1.8E;MPS_Best=%1.8E\n', mean(MPSO_f), std(MPSO_f), min(MPSO_f));
end
diary off