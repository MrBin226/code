clear all
clc
close all
% format long
SearchAgents_no=50; 

Function_name='F9';%F1,F3,F8,F10,F22,F20
   
Max_iteration=200; 

[lb,ub,dim,fobj] = Get_Functions_details(Function_name,50);
tic
[Best_score,Best_pos,Convergence_curve]=MPA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
display(['MPA最优值 : ', num2str(Best_score)]);
toc
tic
[Best_score1,Best_pos1,Convergence_curve1]=MPA1(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
display(['MMPA最优值 : ', num2str(Best_score1)]);
toc
tic
[Best_score2,Best_pos2,Convergence_curve2]=GWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
display(['GWO最优值 : ', num2str(Best_score2)]);
toc
tic
[Best_score3,Convergence_curve3]=PSO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
display(['PSO最优值 : ', num2str(Best_score3)]);
toc


createfigure([Convergence_curve1',Convergence_curve',Convergence_curve2',Convergence_curve3'],Function_name)