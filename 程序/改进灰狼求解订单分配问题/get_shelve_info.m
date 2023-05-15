function data = get_shelve_info(filename,separator)
fid=fopen(filename);
data={};
while ~feof(fid)
   tline = fgetl(fid);
   if isempty(tline)
       data=[data;[]];
       continue;
   else
       S=str2num(char(regexp(tline,separator,'split')))';
       data=[data;S];
   end 
end 
fclose(fid);
