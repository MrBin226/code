function [dist,path] = find_path(start,last,a)
[i,j,v] = find(a);
b = sparse(i,j,v,size(a,1),size(a,1)); %����ϡ�����
[dist,path,~] = graphshortestpath(b,start,last,'directed',false);

end

