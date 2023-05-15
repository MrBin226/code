function [pop]=initPoP(popsize,A,L)
pop=cell(popsize,1);
for i=1:popsize
    temp=correct_solution(round(rand(1,size(A,1))),A);
    build_class=zeros(1,size(A,1));
    select_place=find(temp==1);
    build_class(select_place(select_place>14))=L;
    build_class(select_place(select_place<=14))=round(rand(1,length(select_place(select_place<=14)))+L-2);
    pop{i}=[temp;build_class];
end

