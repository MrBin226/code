%% ����ÿ��������ʻ�ľ��룬�Լ����г���ʻ���ܾ���
%����VC                  ÿ�����������Ĺ˿�
%����dist                �������
%���sumTD               ���г���ʻ���ܾ���
%���everyTD             ÿ��������ʻ�ľ���
function [sumTD,everyTD]=travel_distance(VC,dist)
n=size(VC,1);                        %������
everyTD=zeros(n,1);
for i=1:n
    part_seq=VC{i};                  %ÿ�����������Ĺ˿�
    %��������������˿ͣ���ó�������ʹ�ľ���Ϊ0
    if ~isempty(part_seq)
        everyTD(i)=part_length( part_seq,dist );
    end
end
sumTD=sum(everyTD);                                 %���г���ʻ���ܾ���