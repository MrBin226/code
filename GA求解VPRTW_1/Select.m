%% ѡ�����
%����
%Chrom ��Ⱥ
%FitnV ��Ӧ��ֵ
%GGAP��ѡ�����
%���
%SelCh  ��ѡ��ĸ���
function SelCh=Select(Chrom,FitnV)
NIND=size(Chrom,1);
ChrIx=Sus(FitnV,NIND);
SelCh=Chrom(ChrIx,:);