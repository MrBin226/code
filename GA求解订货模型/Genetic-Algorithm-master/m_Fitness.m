function objvalue=m_Fitness(pop,LT1,C5,Y1,DS,T,C6,P2)
%% ≥…±æº∆À„
r=pop(1,:);
Q=pop(2,:);
objvalue=zeros(size(pop,2),1);
for i=1:size(pop,2)
    if r(i) < LT1
        objvalue(i)=(C5+Q(i)*Y1)*(DS*T)/Q(i)+T*(Q(i)/2)*C6+(LT1-r(i))*(0.4+(LT1-r(i))*0.012)*P2;
    else
        objvalue(i)=(C5+Q(i)*Y1)*(DS*T)/Q(i)+C6*(Q(i)/2+r(i)-LT1)*T;
    end
end
% objvalue=(max(objvalue)-objvalue+10);