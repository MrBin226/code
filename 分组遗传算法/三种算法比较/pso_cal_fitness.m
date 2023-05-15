function [particals,best_pos,best_fitness,best_no] = pso_cal_fitness(particals,R_cpu,R_mem,R_hardDisk,C_cpu,C_mem,C_hardDisk)
N=length(particals);
best_fitness=inf;
best_pos=particals(1).pos;
best_no=particals(1).BinNo;
for i=1:N
    w_cpu=0;
    w_mem=0;
    w_disk=0;
    for j=1:particals(i).BinNo
        idx=find(particals(i).pos==j);
        w_cpu=w_cpu+C_cpu-sum(R_cpu(idx));
        w_mem=w_mem+C_mem-sum(R_mem(idx));
        w_disk=w_disk+C_hardDisk-sum(R_hardDisk(idx));
    end
    particals(i).fitness=w_cpu+w_mem+w_disk;
    particals(i).best_fitness=w_cpu+w_mem+w_disk;
    if particals(i).fitness < best_fitness
        best_fitness=particals(i).fitness;
        best_pos=particals(i).pos;
        best_no=particals(i).BinNo;
    end
end
end


