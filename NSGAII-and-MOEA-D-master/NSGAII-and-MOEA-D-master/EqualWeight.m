function [N,W] = EqualWeight(H,M)
%��������Ȩ��
    N = nchoosek(H+M-1,M-1);%nchoosekΪ���,�÷�nchoosek(N,M),�����N��ѡM�����������,���������
    Temp = nchoosek(1:H+M-1,M-1)-repmat(0:M-2,nchoosek(H+M-1,M-1),1)-1;
    W = zeros(N,M);
    W(:,1) = Temp(:,1)-0;
    for i = 2 : M-1
        W(:,i) = Temp(:,i)-Temp(:,i-1);
    end
    W(:,end) = H-Temp(:,end);
    W = W/H;
end

