function [fit] = cal_fault(I,S,w,net_struct)
%IΪ������и���ص㣨 FTU �� RTU����ʵ��״̬
%S Ϊ������и��豸��״̬
%wΪ��Ӧ�Ⱥ������Ȩϵ��
%net_structΪ���������ṹ
S = Convert2binary(S);%ת��Ϊ������
I_s=zeros(size(I));%�����豸״̬S�õ��ĸ���ص�����״̬
for i=1:length(S)
    if S(i)==1
        I_s(net_struct{i,1})=1;
    end
end
fit=sum(abs(I-I_s))+w*sum(S);
end

