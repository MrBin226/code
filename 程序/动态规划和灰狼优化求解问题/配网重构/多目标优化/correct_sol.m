function [new_x] = correct_sol(x,bb)
%基于环网的编码策略，公共支路只需要放在其中1个环网中，开关1不需要编码（始终闭合）
loop1=[2,3,4,5,18,19,20,33];
loop2=[22,23,24,25,26,27,28,37];
loop3=[8,9,10,11,21,35];
loop4=[6,7,15,16,17,29,30,31,32,36];
loop5=[12,13,14,34];
if ismember(bb,loop1)==1   
   L1=ones(1,8);
   for tt=1:length(bb)
    L1(1,find(loop1==bb(tt)))=0;
   end
   L2=x(:,9:16);
   L3=x(:,17:22);
   L4=x(:,23:32);
   L5=x(:,33:36);
   t2=find(L2==0);
   if isempty(t2)
       L2(1)=0;
   else
       L2(t2(2:end))=1;
   end
   t3=find(L3==0);
   if isempty(t3)
       L3(1)=0;
   else
       L3(t3(2:end))=1;
   end
   t4=find(L4==0);
   if isempty(t4)
       L4(1)=0;
   else
       L4(t4(2:end))=1;
   end
   t5=find(L5==0);
   if isempty(t5)
       L5(1)=0;
   else
       L5(t5(2:end))=1;
   end
   new_x=[L1,L2,L3,L4,L5];
end
if ismember(bb,loop2)==1
   L2=ones(1,8);
   for tt=1:length(bb)
    L2(1,find(loop2==bb(tt)))=0;
   end
   L1=x(:,1:8);
   L3=x(:,17:22);
   L4=x(:,23:32);
   L5=x(:,33:36);
   t1=find(L1==0);
   if isempty(t1)
       L1(1)=0;
   else
       L1(t1(2:end))=1;
   end
   t3=find(L3==0);
   if isempty(t3)
       L3(1)=0;
   else
       L3(t3(2:end))=1;
   end
   t4=find(L4==0);
   if isempty(t4)
       L4(1)=0;
   else
       L4(t4(2:end))=1;
   end
   t5=find(L5==0);
   if isempty(t5)
       L5(1)=0;
   else
       L5(t5(2:end))=1;
   end
   new_x=[L1,L2,L3,L4,L5];
end
if ismember(bb,loop3)==1
   L3=ones(1,6);
   for tt=1:length(bb)
    L3(1,find(loop3==bb(tt)))=0;
   end
   L1=x(:,1:8);
   L2=x(:,9:16);
   L4=x(:,23:32);
   L5=x(:,33:36);
   t1=find(L1==0);
    if isempty(t1)
       L1(1)=0;
   else
       L1(t1(2:end))=1;
   end
   t2=find(L2==0);
   if isempty(t2)
       L2(1)=0;
   else
       L2(t2(2:end))=1;
   end
   t4=find(L4==0);
   if isempty(t4)
       L4(1)=0;
   else
       L4(t4(2:end))=1;
   end
   t5=find(L5==0);
   if isempty(t5)
       L5(1)=0;
   else
       L5(t5(2:end))=1;
   end
   new_x=[L1,L2,L3,L4,L5];
end
if ismember(bb,loop4)==1
   L4=ones(1,10);
   for tt=1:length(bb)
    L4(1,find(loop4==bb(tt)))=0;
   end
   L1=x(:,1:8);
   L2=x(:,9:16);
   L3=x(:,17:22);
   L5=x(:,33:36);
   t1=find(L1==0);
    if isempty(t1)
       L1(1)=0;
   else
       L1(t1(2:end))=1;
   end
   t2=find(L2==0);
   if isempty(t2)
       L2(1)=0;
   else
       L2(t2(2:end))=1;
   end
   t3=find(L3==0);
   if isempty(t3)
       L3(1)=0;
   else
       L3(t3(2:end))=1;
   end
   t5=find(L5==0);
   if isempty(t5)
       L5(1)=0;
   else
       L5(t5(2:end))=1;
   end
   new_x=[L1,L2,L3,L4,L5];
end
if ismember(bb,loop5)==1
   L5=ones(1,4);
   for tt=1:length(bb)
    L5(1,find(loop5==bb(tt)))=0;
   end
   L1=x(:,1:8);
   L2=x(:,9:16);
   L3=x(:,17:22);
   L4=x(:,23:32);
   t1=find(L1==0);
    if isempty(t1)
       L1(1)=0;
   else
       L1(t1(2:end))=1;
   end
   t2=find(L2==0);
   if isempty(t2)
       L2(1)=0;
   else
       L2(t2(2:end))=1;
   end
   t3=find(L3==0);
   if isempty(t3)
       L3(1)=0;
   else
       L3(t3(2:end))=1;
   end
   t4=find(L4==0);
    if isempty(t4)
       L4(1)=0;
   else
       L4(t4(2:end))=1;
   end
   new_x=[L1,L2,L3,L4,L5];
end


end

