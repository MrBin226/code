function [q]=violateLoad(VC,demands,cap)
NV=size(VC,1);                  
q=0;
for i=1:NV
    route=VC{i};
    Ld=leave_load(route,demands);
    if Ld>cap
        q=q+Ld-cap;
    end
end
end