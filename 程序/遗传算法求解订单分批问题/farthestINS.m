function [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,dist,origin_dis,demands,cap )
nr=length(removed);                   %被移出的顾客的数量
outcome=zeros(nr,3);
for i=1:nr
    [civ,cip,C]= cheapestIP( removed(i),rfvc,dist,origin_dis,demands,cap);
    outcome(i,1)=civ;
    outcome(i,2)=cip;
    outcome(i,3)=C;
end
[mc,mc_index]=max(outcome(:,3));
temp=outcome(mc_index,:);
fviv=temp(1,1);
fvip=temp(1,2);
fvC=temp(1,3);
fv=removed(mc_index);

end

