function data = importfile(filename,separator)
fid=fopen(filename);
fgetl(fid);
i=1;
while ~feof(fid)
   tline = fgetl(fid);
   if isempty(tline)
       data(i).order=[];
       data(i).count=[];
       i=i+1;
       continue;
   else
       S=str2num(char(strsplit(tline,separator)));
       data(i).order=S(1,:);
       data(i).count=S(2,:);
       i=i+1;
   end
end 
fclose(fid);
