function [new_path] = cal_middle(path)
if size(path,1)==1
    new_path=[0 0 0];
else
    new_path=[];
    for i=1:size(path,1)-1
        new_path=[new_path;(path(i,:)+path(i+1,:))/2];
    end
end


end

