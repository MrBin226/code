%
%      @���ߣ�����390
%      @΢�Ź��ںţ��Ż��㷨������
%
%% ���ͷ��������֮�����ת��
function chrom=change(VC,N,cusnum)
NV=size(VC,1);                         %����ʹ����Ŀ
chrom=[];
for i=1:NV
    if (cusnum+i)<=N
        chrom=[chrom,VC{i},cusnum+i];
    else
        chrom=[chrom,VC{i}];
    end
end
if length(chrom)<N                          %���Ⱦɫ�峤��С��N������Ҫ��Ⱦɫ������������ı��
    supply=(cusnum+NV+1):N;
    chrom=[chrom,supply];
end

end

