function Chrom=InitPopCW(NIND,N,cusnum,customers_time,customers_demand,cap)
Chrom=zeros(NIND,N);%用于存储种群
for j=1:NIND
    init_vc=init(cusnum,customers_time,customers_demand,cap);                             %构造初始解
    chrom=change(init_vc,N,cusnum);
    flag=0;
    while(ismember(chrom,Chrom,'rows')==1)
        init_vc=init(cusnum,customers_time,customers_demand,cap);
        chrom=change(init_vc,N,cusnum);
        flag=flag+1;
        if(flag>5)
            break;
        end
    end
    Chrom(j,:)=chrom;
end