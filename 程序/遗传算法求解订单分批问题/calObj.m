function ObjV=calObj(Chrom,cusnum,cap,demands,dist,origin_dis,alpha)
NIND=size(Chrom,1);                       
ObjV=zeros(NIND,1);                        
for i=1:NIND
    VC=decode(Chrom(i,:),cusnum,cap,demands,dist,origin_dis);
    costF=costFuction(VC,dist,origin_dis,demands,cap,alpha);
    ObjV(i)=costF;
end
end