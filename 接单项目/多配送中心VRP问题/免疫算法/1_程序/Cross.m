function ret=Cross(pcross,chrom,sizepop,len)
% �������
% pcorss                input  : �������
% chrom                 input  : ����Ⱥ
% sizepop               input  : ��Ⱥ��ģ
% length                input  : ���峤��
% ret                   output : ����õ��Ŀ���Ⱥ

% ÿһ��forѭ���У����ܻ����һ�ν�����������ѡ��Ⱦɫ���Ǻͽ���λ�ã��Ƿ���н���������ɽ�����ʣ�continue������
for i=1:sizepop  
    
    % ���ѡ������Ⱦɫ����н���
    pick=rand;
    while prod(pick)==0
        pick=rand(1);
    end
    
    if pick>pcross
        continue;
    end
    
    % �ҳ��������
    index(1)=unidrnd(sizepop);
    index(2)=unidrnd(sizepop);
    while index(2)==index(1)
        index(2)=unidrnd(sizepop);
    end
    
    % ѡ�񽻲�λ��
    pos=ceil(len*rand);
    while pos==1
        pos=ceil(len*rand);
    end

    % ���彻��
    chrom1=chrom(index(1),:);
    chrom2=chrom(index(2),:);
    
    temp1=setdiff(chrom2,chrom1,'stable');
    temp2=setdiff(chrom1,chrom2,'stable');
    a1 = min(len-pos+1,length(temp1));
    a2 = min(len-pos+1,length(temp2));
    chrom1(len-a1+1:len)=temp1(1:a1);
    chrom2(len-a2+1:len)=temp2(1:a2);
    
%     k=chrom1(pos:length);
%     chrom1(pos:length)=chrom2(pos:length);
%     chrom2(pos:length)=k; 
    
    % ����Լ��������������Ⱥ
    flag1=test(chrom(index(1),:));
    flag2=test(chrom(index(2),:));
    
    if flag1*flag2==1
        chrom(index(1),:)=chrom1;
        chrom(index(2),:)=chrom2;
    end
    
end

ret=chrom;
end