%
%      @���ߣ�����390
%      @΢�Ź��ںţ��Ż��㷨������
%
%% ��ʼ����Ⱥ
%����NIND��                ��Ⱥ��С
%����N��                   Ⱦɫ�峤��
%���룺cusnum              �˿���Ŀ
%����init_vc��             ��ʼ���ͷ���
%���Chrom��               ��ʼ��Ⱥ

function Chrom=InitPopCW(NIND,N,cusnum,init_vc)
Chrom=zeros(NIND,N);%���ڴ洢��Ⱥ
chrom=change(init_vc,N,cusnum);
for j=1:NIND
    Chrom(j,:)=chrom;
end