function [fitness] = cal_fitness(pop,wlength,lsource,system,rgb,xyz,lsources,st)
%计算适应度函数
[m,~]=size(pop);
fitness=zeros(m,1);
for i=1:m
    M=reshape(pop(i,:),3,3);
    fitness(i)=norm(xyz-M*rgb)...
                 +norm( (xyz -M*rgb),Inf)...   
                 +sum( std(xyz-M*rgb) )...
                 +sum( min( abs(xyz-M*rgb)));
%     lab1=XYZ_2_Lab(xyz',wlength,lsource,system,lsources,st);
%     lab2=XYZ_2_Lab((M*rgb)',wlength,lsource,system,lsources,st);
%     E94=deltaE94(lab1,lab2);
%     error=sqrt(sum((lab1-lab2)'.^2));
%     fitness(i)=0.85*mean(E94)+0.15*max(E94);
%     fitness(i)=0.85*mean(error)+0.15*max(error);
end
end

