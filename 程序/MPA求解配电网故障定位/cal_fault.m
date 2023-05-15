function [fit] = cal_fault(I,S,w,net_struct)
%I为配电网中各测控点（ FTU 或 RTU）的实际状态
%S 为配电网中各设备的状态
%w为适应度函数里的权系数
%net_struct为配电网网络结构
S = Convert2binary(S);%转化为二进制
I_s=zeros(size(I));%根据设备状态S得到的各测控点期望状态
for i=1:length(S)
    if S(i)==1
        I_s(net_struct{i,1})=1;
    end
end
fit=sum(abs(I-I_s))+w*sum(S);
end

