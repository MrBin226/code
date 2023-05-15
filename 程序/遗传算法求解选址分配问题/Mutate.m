function SelCh=Mutate(SelCh,mutate_rate,A,L)
N=length(SelCh);
D=size(SelCh{1},2);
for i=1:N
    for j=1:D
        if rand()<mutate_rate
            SelCh{i}(1,j)=double(~SelCh{i}(1,j));
            if j <= 14
                SelCh{i}(2,j)=round(rand()+L-2);
            else
                SelCh{i}(2,j)=3;
            end
        end
    end
    SelCh{i}(1,:)=correct_solution(SelCh{i}(1,:),A);
    t1=SelCh{i}(1,:);
    s1=find(t1==1);
    b1=find(SelCh{i}(2,:)>0);
    SelCh{i}(2,setdiff(b1,s1))=0;
    a1=setdiff(s1,b1);
    SelCh{i}(2,a1(a1<=14))=round(rand(1,length(a1(a1<=14)))+L-2);
    SelCh{i}(2,a1(a1>14))=L;
end

end

