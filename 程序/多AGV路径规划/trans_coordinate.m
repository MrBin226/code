function [coordinate] = trans_coordinate(parameter)

coordinate=[];
for i=1:size(parameter,1)
    for j=0:parameter(i,3)-1
        for k=0:parameter(i,4)-1
            coordinate=[coordinate;[parameter(i,1)+j,parameter(i,2)+k]];
        end
    end
end
end

