function [ new_pop ] = extremum_select( pop,fitness,N,D,M )
%极值筛选法
%   此处显示详细说明
temp_pop=pop(fitness<=0.01*abs(M),:);
temp_pop=sortrows(temp_pop,2);
[m,~]=size(temp_pop);
range = ceil(m/2)-floor((D-N)/2):ceil(m/2)+D-N-floor((D-N)/2)-1;
temp_pop(range,:)=[];
new_pop=temp_pop;
end

