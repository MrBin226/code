function SelCh = select(pop,ObjV)
N=length(pop);
SelCh =cell(N,1);
for i=1:N
    t=randperm(N,2);
    if ObjV(t(1))<ObjV(t(2))
        SelCh(i)=pop(t(1));
    else
        SelCh(i)=pop(t(2));
    end
end

end

