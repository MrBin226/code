function f=GGA_cal_fitness(chrom,binno,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk)
[N,~]=size(chrom);
f=zeros(N,1);
for i=1:N
    w_cpu=0;
    w_mem=0;
    w_disk=0;
    for j=1:binno(i)
        w_cpu=w_cpu+C_cpu-sum(R_cpu(chrom{i,j}));
        w_mem=w_mem+C_mem-sum(R_mem(chrom{i,j}));
        w_disk=w_disk+C_hardDisk-sum(R_hardDisk(chrom{i,j}));
    end
    f(i)=w_cpu+w_mem+w_disk;
end
end