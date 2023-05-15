function SelCh=crossover(SelCh,cross_rate,A,L)
% Á½µã½»²æ
N=length(SelCh);
D=size(SelCh{1},2);
if mod(N,2)
    N=N-1;
end
for i=1:2:N
    if rand()<cross_rate
        c1=randi(floor(D/2));
        c2=randi(floor(D/2))+floor(D/2);
        temp=SelCh{i}(:,c1:c2);
        SelCh{i}(:,c1:c2)=SelCh{i+1}(:,c1:c2);
        SelCh{i+1}(:,c1:c2)=temp;
        SelCh{i}(1,:)=correct_solution(SelCh{i}(1,:),A);
        SelCh{i+1}(1,:)=correct_solution(SelCh{i+1}(1,:),A);
        t1=SelCh{i}(1,:);
        t2=SelCh{i+1}(1,:);
        s1=find(t1==1);
        b1=find(SelCh{i}(2,:)>0);
        SelCh{i}(2,setdiff(b1,s1))=0;
        a1=setdiff(s1,b1);
        SelCh{i}(2,a1(a1<=14))=round(rand(1,length(a1(a1<=14)))+L-2);
        SelCh{i}(2,a1(a1>14))=L;
        s2=find(t2==1);
        b2=find(SelCh{i+1}(2,:)>0);
        SelCh{i+1}(2,setdiff(b2,s2))=0;
        a2=setdiff(s2,b2);
        SelCh{i+1}(2,a2(a2<=14))=round(rand(1,length(a2(a2<=14)))+L-2);
        SelCh{i+1}(2,a2(a2>14))=L;
    end
end

end

