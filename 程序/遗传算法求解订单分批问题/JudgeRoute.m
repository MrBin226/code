function flagR=JudgeRoute(route,demands,cap)
flagR=1;                        
Ld=leave_load(route,demands);  
if Ld>cap
    flagR=0;
end
end