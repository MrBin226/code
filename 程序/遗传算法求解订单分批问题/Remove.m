function [removed,rfvc] = Remove(cusnum,toRemove,D,dist,final_vehicles_customer)
%% Remove
inplan=1:cusnum;           
visit=ceil(rand*cusnum);  
inplan(inplan==visit)=[];   
removed=[visit];           
while length(removed)<toRemove
    nr=length(removed);            
    vr=ceil(rand*nr);         
    nip=length(inplan);         
    R=zeros(1,nip);          
    for i=1:nip
        R(i)=Relatedness( removed(vr),inplan(i),dist,final_vehicles_customer);
    end
    [SRV,SRI]=sort(R,'descend');        
    lst=inplan(SRI);            
    vc=lst(ceil(rand^D*nip));     
    removed=[removed vc];        
    inplan(inplan==vc)=[];       
end
rfvc=final_vehicles_customer;            
nre=length(removed);                      
NV=size(final_vehicles_customer,1);     
for i=1:NV
    route=final_vehicles_customer{i};
    for j=1:nre
        findri=find(route==removed(j),1,'first');
        if ~isempty(findri)
            route(route==removed(j))=[];
        end
    end
    rfvc{i}=route;
end

[ rfvc,~ ] = deal_vehicles_customer( rfvc );

end

