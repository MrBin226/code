function Chrom=InitPopCW(NIND,N,cusnum,customers_time,customers_demand,cap)
Chrom=zeros(NIND,N);%���ڴ洢��Ⱥ
for j=1:NIND
    init_vc=init(cusnum,customers_time,customers_demand,cap);                             %�����ʼ��
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