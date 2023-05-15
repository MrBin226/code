function [chromosome,BinNo] = GGA_initPoP(popsize,itemno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk)
chromosome=cell(popsize,1);%种群
BinNo=zeros(popsize,1);%每个个体使用机器的数量
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
    chromosome{ch_index,bindex}=[permu(1)];
    while(iindex<=itemno)
        if(summ1+item_cpu(iindex)<=C_cpu && summ2+item_mem(iindex)<=C_mem && summ3+item_disk(iindex)<=C_hardDisk)
            if(summ1==0)
                chromosome{ch_index,bindex}=permu(iindex);
            else
                chromosome{ch_index,bindex}=[chromosome{ch_index,bindex},permu(iindex)];
            end
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
end
end

