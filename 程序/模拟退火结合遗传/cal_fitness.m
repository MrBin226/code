function fitness = cal_fitness(pop,fismat)
fitness=zeros(size(pop,1),1);
for i=1:size(pop,1)
    % �����������õ����C
    C=evalfis(pop(i,:),fismat);
    % ����Ŀ�꺯��
    fitness(i)=0.25*C-0.25*0.011304*pop(i,3)*pop(i,4)-0.25*0.0009324*pop(i,3)^2*sin(deg2rad(pop(i,2)))-0.25*0.37*pop(i,4)+1;
end

end

