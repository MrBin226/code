function new_pop=crossover(pop,cross_rate,num)
[m,n]=size(pop);
new_pop=cell(m,n);
if mod(m,2)
    m=m-1;
end
c_idx=1:num;
for i=1:2:m
    idx=1:n;
    if rand()<cross_rate
        n1=pop(i,:);
        n2=pop(i+1,:);
        t=randi(n,1,2);
        temp=n1(t(1));
        n1(t(1))=n2(t(2));
        n2(t(2))=temp;
        index1=idx(idx~=t(1));
        index2=idx(idx~=t(2));
        for k=1:length(index1)
            n1{index1(k)}=setdiff(n1{index1(k)},n1{t(1)});
            n2{index2(k)}=setdiff(n2{index2(k)},n2{t(2)});
        end
        a1=[];
        for k=1:n
            a1=[a1 n1{k}];
        end
        a2=[];
        for k=1:n
            a2=[a2 n2{k}];
        end
        dis1=setdiff(c_idx,a1);
        dis2=setdiff(c_idx,a2);
        r1=cellfun(@length,n1);
        r2=cellfun(@length,n2);
        if ~isempty(dis1)
            for k=1:length(dis1)
                [~,idx]=min(r1);
                n1{idx}=[n1{idx} dis1(k)];
                r1=cellfun(@length,n1);
            end
        end
        if ~isempty(dis2)
            for k=1:length(dis2)
                [~,idx]=min(r2);
                n2{idx}=[n2{idx} dis2(k)];
                r2=cellfun(@length,n2);
            end
        end
        new_pop(i,:)=n1;
        new_pop(i+1,:)=n2;
    else
        new_pop(i,:)=pop(i,:);
        new_pop(i+1,:)=pop(i+1,:);
    end
end
end

