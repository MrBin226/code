function [a b] = judge_kg(pop1,bb)
%�ж�һ����Ⱥ����Ҫ�����Ŀ���
%openkg��ʾ��Ҫ�򿪵Ŀ���
%closekg��ʾ��Ҫ�պϵĿ���
S=transform(pop1);
zhilu=ones(1,37);
for k=1:37             %zhilu��37��֧·��״̬
    if k==S(1)
       zhilu(k)=0;
    end
    if k==S(2)
       zhilu(k)=0;
    end
    if k==S(3)
       zhilu(k)=0;
    end
    if k==S(4)
       zhilu(k)=0;
    end
    if k==S(5)
       zhilu(k)=0;
    end
end
h=1;
for k=1:32   
    if zhilu(k)==0    %�жϴ򿪵�֧·
       %if k~=bb       %��֤���ǹ���֧·
        a(h)=k;
        h=h+1;
      % end
    end
end
if h==1   %�ж��Ƿ���ڲ���Ҫ�򿪿��ص���� a=0��ʾû��Ҫ�򿪵Ŀ���
    a=0; 
end
t=1;
for k=33:37
     if zhilu(k)==1    %�жϱպϵ�֧·
        b(t)=k;
        t=t+1;
     end
end
if t==1  %�ж��Ƿ���ڲ���Ҫ�򿪿��ص���� b=0��ʾû��Ҫ�򿪵Ŀ���
    b=0; 
end
end

