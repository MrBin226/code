function [sumTD,everyTD]=travel_distance(VC,dist,origin_dis)
n=size(VC,1);                       
everyTD=zeros(n,1);
for i=1:n
    part_seq=VC{i};                 
    if ~isempty(part_seq)
        everyTD(i)=part_length( part_seq,dist ,origin_dis);
    end
end
sumTD=sum(everyTD);                       