%
%      @���ߣ�����
%      @΢�Ź��ںţ��Ż��㷨������
%���ò�ֽ�����ʽ���б���
function result=mutate(chrom,i,F,carnum,cusnum)
[m,~]=size(chrom);
while 1
    while 1
        r1=randi(m);
        r2=randi(m);
        r3=randi(m);
        if r1~=r2 && r2~=r3 && r3~=r1 && r1~=i && r2~=i && r3~=i
            break;
        end
    end
result=chrom(r1,:)+F*(chrom(r2,:)-chrom(r3,:));
if length(find(result==0))<carnum
    break;
end
end
result=legal(result,carnum);
result(result>cusnum)=0;
end