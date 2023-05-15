function [chromosome,BinNo] = initPoP(popsize,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk)
chromosome=zeros(popsize,itemno);
BinNo=zeros(popsize,1);
for ch_index=1:popsize
    iindex=2;
    bindex=1;
    permu=randperm(itemno);
    item_cpu=R_cpu(permu);
    item_mem=R_mem(permu);
    item_disk=R_hardDisk(permu);
    summ1=item_cpu(1);
    summ2=item_mem(1);
    summ3=item_disk(1);
    temp=zeros(1,itemno);
    temp(1)=bindex;
    while(iindex<=itemno)
        if(summ1+item_cpu(iindex)<=C_cpu && summ2+item_mem(iindex)<=C_mem && summ3+item_disk(iindex)<=C_hardDisk)
            temp(iindex)=bindex;
        summ1=summ1+item_cpu(iindex);
        summ2=summ2+item_mem(iindex);
        summ3=summ3+item_disk(iindex);
        iindex=iindex+1;
        else
            bindex=bindex+1;
            summ1=0;
            summ2=0;
            summ3=0;
        end
    end
    BinNo(ch_index)=bindex;
    for kk=1:bindex
        chromosome(ch_index,permu(temp==kk))=kk;
    end
end
end

