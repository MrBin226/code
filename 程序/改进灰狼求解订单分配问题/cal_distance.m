function [distance] = cal_distance(seq,coord)

distance=0;
for i=1:length(seq)-1
    distance=distance+abs(coord(i,1)-coord(i+1,1))+abs(coord(i,2)-coord(i+1,2));
end


end

