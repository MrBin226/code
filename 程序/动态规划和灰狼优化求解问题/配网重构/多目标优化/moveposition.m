%����任
%���������pop�������Ƶĸ�����Ⱥ����pc����λ�ĸ���
%���������newpop����λ�����Ⱥ��
function [newpop] = moveposition(pop,pc,bb)
[px,py] = size(pop);
newpop = ones(size(pop));
L1=pop(:,1:8);%���ڻ�����Ⱦɫ��
L2=pop(:,9:16);
L3=pop(:,17:22);
L4=pop(:,23:32);
L5=pop(:,33:36);
%���ڻ����ı�����ԣ�����֧·ֻ��Ҫ��������1�������У�����1����Ҫ���루ʼ�ձպϣ�
loop1=[2,3,4,5,18,19,20,33];
loop2=[22,23,24,25,26,27,28,37];
loop3=[8,9,10,11,21,35];
loop4=[6,7,15,16,17,29,30,31,32,36];
loop5=[12,13,14,34];
%��Ҫ�жϹ���֧·���ĸ���������Ӧ�Ļ�������Ҫ��������֤����֧·ʼ����0
if ismember(bb,loop1)==1
    for i = 1:px
        if(rand<pc)
            mjuzhen=[2,3,4,5];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==2
               L2(i,:)=circshift(L2(i,:)',1)';    
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==3
               L3(i,:)=circshift(L3(i,:)',1)';        
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==4
               L4(i,:)=circshift(L4(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==5
               L5(i,:)=circshift(L5(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end        
        else
            newpop(i,:) = pop(i,:);
        end
    end
end
if ismember(bb,loop2)==1
    for i = 1:px
        if(rand<pc)
            mjuzhen=[1,3,4,5];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==1
               L1(i,:)=circshift(L1(i,:)',1)';    
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==3
               L3(i,:)=circshift(L3(i,:)',1)';        
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==4
               L4(i,:)=circshift(L4(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==5
               L5(i,:)=circshift(L5(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end        
        else
            newpop(i,:) = pop(i,:);
        end
    end
end
if ismember(bb,loop3)==1
    for i = 1:px
        if(rand<pc)
            mjuzhen=[1,2,4,5];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==1
               L1(i,:)=circshift(L1(i,:)',1)';    
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==2
               L2(i,:)=circshift(L2(i,:)',1)';        
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==4
               L4(i,:)=circshift(L4(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==5
               L5(i,:)=circshift(L5(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end        
        else
            newpop(i,:) = pop(i,:);
        end
    end
end
if ismember(bb,loop4)==1
    for i = 1:px
        if(rand<pc)
            mjuzhen=[1,2,3,5];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==1
               L1(i,:)=circshift(L1(i,:)',1)';    
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==2
               L2(i,:)=circshift(L2(i,:)',1)';        
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==3
               L3(i,:)=circshift(L3(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==5
               L5(i,:)=circshift(L5(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end        
        else
            newpop(i,:) = pop(i,:);
        end
    end
end
if ismember(bb,loop5)==1
    for i = 1:px
        if(rand<pc)
            mjuzhen=[1,2,3,4];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==1
               L1(i,:)=circshift(L1(i,:)',1)';    
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==2
               L2(i,:)=circshift(L2(i,:)',1)';        
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==3
               L3(i,:)=circshift(L3(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==4
               L4(i,:)=circshift(L4(i,:)',1)';   
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end        
        else
            newpop(i,:) = pop(i,:);
        end
    end
end

end