%% ɾ����Ⱥ���ظ����壬������ɾ���ĸ���
% ����Chrom����Ⱥ
% ���dChrom��������ظ��������Ⱥ
function dChrom=deal_Repeat(Chrom,shelve_num)
N=size(Chrom,1);                                    %��Ⱥ��Ŀ
len=size(Chrom,2);                                  %Ⱦɫ�峤��
dChrom=unique(Chrom,'rows');                        %ɾ���ظ������
Nd=size(dChrom,1);                                  %ʣ�������Ŀ
while N-Nd>0
    newChrom=initPoP(N-Nd,len,shelve_num);
    dChrom=[dChrom;newChrom];
    dChrom=unique(dChrom,'rows');                        %ɾ���ظ������
    Nd=size(dChrom,1);                                  %ʣ�������Ŀ
end
end

