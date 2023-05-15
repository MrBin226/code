function pop=initialization(popsize,bb)
loop1=[2,3,4,5,18,19,20,33];%8个
loop2=[22,23,24,25,26,27,28,37];%8个
loop3=[8,9,10,11,21,35];%6个
loop4=[6,7,15,16,17,29,30,31,32,36];%10个
loop5=[12,13,14,34];%4个
%需要判断一下故障支路在哪个环网上，确保故障支路置0
if ismember(bb,loop1)==1   
   L1=ones(1,8);
  for tt=1:length(bb)
    L1(1,find(loop1==bb(tt)))=0;
   end
   for k=1:popsize
        while 1
          L2=ones(1,8);
          L3=ones(1,6);
          L4=ones(1,10);
          L5=ones(1,4);
          L2(1,round(rand*7)+1)=0;
          L3(1,round(rand*5)+1)=0;
          L4(1,round(rand*9)+1)=0;
          L5(1,round(rand*3)+1)=0;
          pop(k,:)=[L1,L2,L3,L4,L5];
          if ismember(pop(k,:),pop(1:k-1,:),'rows')==1 %判断生成的个体与前面不重复
              continue;
          end
          break;
        end  
  end 
end
if ismember(bb,loop2)==1
   L2=ones(1,8);
  for tt=1:length(bb)
    L2(1,find(loop2==bb(tt)))=0;
   end
   for k=1:popsize
        while 1
          L1=ones(1,8);
          L3=ones(1,6);
          L4=ones(1,10);
          L5=ones(1,4);
          L1(1,round(rand*7)+1)=0;
          L3(1,round(rand*5)+1)=0;
          L4(1,round(rand*9)+1)=0;
          L5(1,round(rand*3)+1)=0;
          pop(k,:)=[L1,L2,L3,L4,L5];
          if ismember(pop(k,:),pop(1:k-1,:),'rows')==1 %判断生成的个体与前面不重复
              continue;
          end
          break;
        end  
  end 
end
if ismember(bb,loop3)==1
   L3=ones(1,6);
   for tt=1:length(bb)
    L3(1,find(loop3==bb(tt)))=0;
   end
   for k=1:popsize
        while 1
          L1=ones(1,8);
          L2=ones(1,8);
          L4=ones(1,10);
          L5=ones(1,4);
          L1(1,round(rand*7)+1)=0;
          L2(1,round(rand*7)+1)=0;
          L4(1,round(rand*9)+1)=0;
          L5(1,round(rand*3)+1)=0;
          pop(k,:)=[L1,L2,L3,L4,L5];
          if ismember(pop(k,:),pop(1:k-1,:),'rows')==1 %判断生成的个体与前面不重复
              continue;
          end
          break;
        end  
  end  
end
if ismember(bb,loop4)==1
   L4=ones(1,10);
   for tt=1:length(bb)
    L4(1,find(loop4==bb(tt)))=0;
   end
   for k=1:popsize
        while 1
          L1=ones(1,8);
          L2=ones(1,8);
          L3=ones(1,6);
          L5=ones(1,4);
          L1(1,round(rand*7)+1)=0;
          L2(1,round(rand*7)+1)=0;
          L3(1,round(rand*5)+1)=0;
          L5(1,round(rand*3)+1)=0;
          pop(k,:)=[L1,L2,L3,L4,L5];
          if ismember(pop(k,:),pop(1:k-1,:),'rows')==1 %判断生成的个体与前面不重复
              continue;
          end
          break;
        end  
  end  
end
if ismember(bb,loop5)==1
   L5=ones(1,4);
   for tt=1:length(bb)
    L5(1,find(loop5==bb(tt)))=0;
   end
   for k=1:popsize
        while 1
          L1=ones(1,8);
          L2=ones(1,8);
          L3=ones(1,6);
          L4=ones(1,10);
          L1(1,round(rand*7)+1)=0;
          L2(1,round(rand*7)+1)=0;
          L3(1,round(rand*5)+1)=0;
          L4(1,round(rand*9)+1)=0;
          pop(k,:)=[L1,L2,L3,L4,L5];
          if ismember(pop(k,:),pop(1:k-1,:),'rows')==1 %判断生成的个体与前面不重复
              continue;
          end
          break;
        end  
  end 
end
end