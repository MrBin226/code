%���ڱ���
%����˵��
%���������pop����Ⱥ��pm���������
%���������newpop�����Ժ����Ⱥ
function [newpop] = mutation(pop,pm,bb)
[px,py] = size(pop);
newpop = ones(size(pop));
L1=pop(:,1:8); %���ڻ�����Ⱦɫ��
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
%��Ҫ�жϹ���֧·���ĸ������ϣ���Ӧ�Ļ�������Ҫ��������֤����֧·ʼ����0
if ismember(bb,loop1)==1
    for i = 1:px
        if(rand<pm)
            mjuzhen=[2,3,4,5];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==2
               spoint=round(rand*(size(L2,2)-1))+1; %ѡ�����λ
               if L2(i,spoint)==0
                  L2(i,spoint)=1;
                  if (spoint+1)<=size(L2,2)         
                      L2(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L2(i,1)=0;
                  end
               end
               if L2(i,spoint)==1
                   L2(i,find(L2(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L2(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==3
              spoint=round(rand*(size(L3,2)-1))+1; %ѡ�����λ
               if L3(i,spoint)==0
                  L3(i,spoint)=1;
                  if (spoint+1)<=size(L3,2)         
                      L3(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L3(i,1)=0;
                  end
               end
               if L3(i,spoint)==1
                   L3(i,find(L3(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L3(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==4
               spoint=round(rand*(size(L4,2)-1))+1; %ѡ�����λ
               if L4(i,spoint)==0
                  L4(i,spoint)=1;
                  if (spoint+1)<=size(L4,2)         
                      L4(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L4(i,1)=0;
                  end
               end
               if L4(i,spoint)==1
                   L4(i,find(L4(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L4(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==5
               spoint=round(rand*(size(L5,2)-1))+1; %ѡ�����λ
               if L5(i,spoint)==0
                  L5(i,spoint)=1;
                  if (spoint+1)<=size(L5,2)         
                      L5(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L5(i,1)=0;
                  end
               end
               if L5(i,spoint)==1
                   L5(i,find(L5(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L5(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
        else newpop(i,:) = pop(i,:);
        end
    end
end
if ismember(bb,loop2)==1
    for i = 1:px
        if(rand<pm)
            mjuzhen=[1,3,4,5];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==1
               spoint=round(rand*(size(L1,2)-1))+1; %ѡ�����λ
               if L1(i,spoint)==0
                  L1(i,spoint)=1;
                  if (spoint+1)<=size(L1,2)         
                      L1(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L1(i,1)=0;
                  end
               end
               if L1(i,spoint)==1
                   L1(i,find(L1(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L1(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==3
              spoint=round(rand*(size(L3,2)-1))+1; %ѡ�����λ
               if L3(i,spoint)==0
                  L3(i,spoint)=1;
                  if (spoint+1)<=size(L3,2)         
                      L3(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L3(i,1)=0;
                  end
               end
               if L3(i,spoint)==1
                   L3(i,find(L3(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L3(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==4
               spoint=round(rand*(size(L4,2)-1))+1; %ѡ�����λ
               if L4(i,spoint)==0
                  L4(i,spoint)=1;
                  if (spoint+1)<=size(L4,2)         
                      L4(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L4(i,1)=0;
                  end
               end
               if L4(i,spoint)==1
                   L4(i,find(L4(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L4(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==5
               spoint=round(rand*(size(L5,2)-1))+1; %ѡ�����λ
               if L5(i,spoint)==0
                  L5(i,spoint)=1;
                  if (spoint+1)<=size(L5,2)         
                      L5(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L5(i,1)=0;
                  end
               end
               if L5(i,spoint)==1
                   L5(i,find(L5(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L5(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
        else newpop(i,:) = pop(i,:);
        end
    end
end
if ismember(bb,loop3)==1
    for i = 1:px
        if(rand<pm)
            mjuzhen=[1,2,4,5];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==1
               spoint=round(rand*(size(L1,2)-1))+1; %ѡ�����λ
               if L1(i,spoint)==0
                  L1(i,spoint)=1;
                  if (spoint+1)<=size(L1,2)         
                      L1(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L1(i,1)=0;
                  end
               end
               if L1(i,spoint)==1
                   L1(i,find(L1(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L1(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==2
              spoint=round(rand*(size(L2,2)-1))+1; %ѡ�����λ
               if L2(i,spoint)==0
                  L2(i,spoint)=1;
                  if (spoint+1)<=size(L2,2)         
                      L2(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L2(i,1)=0;
                  end
               end
               if L2(i,spoint)==1
                   L2(i,find(L2(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L2(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==4
               spoint=round(rand*(size(L4,2)-1))+1; %ѡ�����λ
               if L4(i,spoint)==0
                  L4(i,spoint)=1;
                  if (spoint+1)<=size(L4,2)         
                      L4(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L4(i,1)=0;
                  end
               end
               if L4(i,spoint)==1
                   L4(i,find(L4(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L4(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==5
               spoint=round(rand*(size(L5,2)-1))+1; %ѡ�����λ
               if L5(i,spoint)==0
                  L5(i,spoint)=1;
                  if (spoint+1)<=size(L5,2)         
                      L5(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L5(i,1)=0;
                  end
               end
               if L5(i,spoint)==1
                   L5(i,find(L5(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L5(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
        else newpop(i,:) = pop(i,:);
        end
    end
end
if ismember(bb,loop4)==1
    for i = 1:px
        if(rand<pm)
            mjuzhen=[1,2,3,5];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==1
               spoint=round(rand*(size(L1,2)-1))+1; %ѡ�����λ
               if L1(i,spoint)==0
                  L1(i,spoint)=1;
                  if (spoint+1)<=size(L1,2)         
                      L1(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L1(i,1)=0;
                  end
               end
               if L1(i,spoint)==1
                   L1(i,find(L1(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L1(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==2
              spoint=round(rand*(size(L2,2)-1))+1; %ѡ�����λ
               if L2(i,spoint)==0
                  L2(i,spoint)=1;
                  if (spoint+1)<=size(L2,2)         
                      L2(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L2(i,1)=0;
                  end
               end
               if L2(i,spoint)==1
                   L2(i,find(L2(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L2(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==3
               spoint=round(rand*(size(L3,2)-1))+1; %ѡ�����λ
               if L3(i,spoint)==0
                  L3(i,spoint)=1;
                  if (spoint+1)<=size(L3,2)         
                      L3(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L3(i,1)=0;
                  end
               end
               if L3(i,spoint)==1
                   L3(i,find(L3(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L3(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==5
               spoint=round(rand*(size(L5,2)-1))+1; %ѡ�����λ
               if L5(i,spoint)==0
                  L5(i,spoint)=1;
                  if (spoint+1)<=size(L5,2)         
                      L5(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L5(i,1)=0;
                  end
               end
               if L5(i,spoint)==1
                   L5(i,find(L5(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L5(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
        else newpop(i,:) = pop(i,:);
        end
    end
end
if ismember(bb,loop5)==1
    for i = 1:px
        if(rand<pm)
            mjuzhen=[1,2,3,4];
            cpoint = mjuzhen(round(rand*3)+1);%ѡ������
            if cpoint==1
               spoint=round(rand*(size(L1,2)-1))+1; %ѡ�����λ
               if L1(i,spoint)==0
                  L1(i,spoint)=1;
                  if (spoint+1)<=size(L1,2)         
                      L1(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L1(i,1)=0;
                  end
               end
               if L1(i,spoint)==1
                   L1(i,find(L1(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L1(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==2
              spoint=round(rand*(size(L2,2)-1))+1; %ѡ�����λ
               if L2(i,spoint)==0
                  L2(i,spoint)=1;
                  if (spoint+1)<=size(L2,2)         
                      L2(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L2(i,1)=0;
                  end
               end
               if L2(i,spoint)==1
                   L2(i,find(L2(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L2(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==3
               spoint=round(rand*(size(L3,2)-1))+1; %ѡ�����λ
               if L3(i,spoint)==0
                  L3(i,spoint)=1;
                  if (spoint+1)<=size(L3,2)         
                      L3(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L3(i,1)=0;
                  end
               end
               if L3(i,spoint)==1
                   L3(i,find(L3(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L3(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
            if cpoint==4
               spoint=round(rand*(size(L4,2)-1))+1; %ѡ�����λ
               if L4(i,spoint)==0
                  L4(i,spoint)=1;
                  if (spoint+1)<=size(L4,2)         
                      L4(i,spoint+1)=0;  %��һλ��Ϊ0
                  else
                      L4(i,1)=0;
                  end
               end
               if L4(i,spoint)==1
                   L4(i,find(L4(i,:)==0))=1;%ԭ��Ϊ0����Ϊ1
                   L4(i,spoint)=0;
               end
               newpop(i,:)=[L1(i,:),L2(i,:),L3(i,:),L4(i,:),L5(i,:)];
            end
        else newpop(i,:) = pop(i,:);
        end
    end
end
end

