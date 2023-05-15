function [chromosome] = correct_solution(chromosome,A)
while true
temp=sum(A(chromosome==1,:),1);
col= find(chromosome==0);
if sum(temp == 0)
    U= find(temp == 0);
    [~,idx]=max(sum(A(col,U),2));
    chromosome(col(idx))=1;
else
    break;
end

end

