function [VC,num,vc_model]=decode(gen1,gen2,demand,vehicle_cap)
VC={};
num=1;
cusnum=length(gen1);
route=[];
load=0;
i=1;
while i<=cusnum
    if load+demand(gen1(i))<=vehicle_cap(gen2(num))
        load=load+demand(gen1(i));
        route=[route,gen1(i)];
        if i==cusnum
            VC{num}=route;
            break
        end
        i=i+1;
    else
        VC{num}=route;
        route=[];
        load=0;
        num=num+1;
    end
end
vc_model=gen2(1:num);
end

