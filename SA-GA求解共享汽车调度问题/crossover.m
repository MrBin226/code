function  [new_pop]=crossover(pop,crossover_rate)
[m,n]=size(pop);
new_pop=pop;
offersize=floor(m/2);
for i=1:offersize
    if rand() < crossover_rate
        t=floor(n/2);
        cross1=randi(t);
        cross2=randi(t)+t;
        new_pop(i*2-1,cross1:cross2)=pop(i*2,cross1:cross2);
    end
end

end

