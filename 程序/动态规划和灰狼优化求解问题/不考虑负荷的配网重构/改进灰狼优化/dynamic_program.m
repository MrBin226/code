function [max_value, decision_result] = dynamic_program(weight_value, capacity,c)
%��̬�滮���01��������
%   weight_value���������
%   capacity: Լ������
%   c:��λ��ֵ
%   max_value������ֵ
%   decision_result�����߽��
capacity=int32(capacity);
n=size(weight_value, 1);
decision_result=zeros(1,n);
results=zeros(n+1,capacity(1)+1,capacity(2)+1);
for i=1:n
    for j=1:capacity(1)
        for t=1:capacity(2)
            if j < weight_value(i,1) || t < weight_value(i,2)
                % ������Լ��
                results(i+1,j+1,t+1)=results(i,j+1,t+1);
            else
                results(i+1,j+1,t+1)=max(results(i,j-weight_value(i,1)+1,t-weight_value(i,2)+1)+weight_value(i,1)*c(i),results(i,j+1,t+1));
            end
        end
    end
end
max_value=results(end,end,end);
r=capacity+1;
seq=sort(1:n,'descend' );
weight_value=int32(weight_value);
for k=seq
    if abs(results(k+1,r(1),r(2)) - results(k,r(1),r(2))) < 1e-12
        decision_result(k)=0;
    else
        decision_result(k)=1;
        r=r-weight_value(k,:);
    end
end

end

