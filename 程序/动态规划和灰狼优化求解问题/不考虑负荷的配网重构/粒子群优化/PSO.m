function [gBest,cg_curve]=PSO(N,Max_iteration,lb,ub,dim,fobj,con_charge,S_source,bb)


Vmax=2;
noP=N;
wMax=0.9;
wMin=0.2;
c1=2;
c2=2;


iter=Max_iteration;
vel=zeros(noP,dim);
pBestScore=zeros(noP);
pBest=zeros(noP,dim);
gBest=zeros(1,dim);
cg_curve=zeros(1,iter);


pos=initialization(noP,bb); 

for i=1:noP
    pBestScore(i)=-inf;
end


 gBestScore=-inf;
     
    
for l=1:iter 
    

     Flag4ub=pos(i,:)>ub;
     Flag4lb=pos(i,:)<lb;
     pos(i,:)=(pos(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
    
    for i=1:size(pos,1)     

        fitness=fobj(pos(i,:),con_charge,S_source,bb);

        if(pBestScore(i)<fitness)
            pBestScore(i)=fitness;
            pBest(i,:)=pos(i,:);
        end
        if(gBestScore<fitness)
            gBestScore=fitness;
            gBest=pos(i,:);
        end
    end


    w=wMax-l*((wMax-wMin)/iter);

    for i=1:size(pos,1)
        rr=rand();
        for j=1:size(pos,2)       
            vel(i,j)=w*vel(i,j)+c1*rand()*(pBest(i,j)-pos(i,j))+c2*rand()*(gBest(j)-pos(i,j));
            
            if(vel(i,j)>Vmax)
                vel(i,j)=Vmax;
            end
            if(vel(i,j)<-Vmax)
                vel(i,j)=-Vmax;
            end
            if rr<1/(1+exp(-vel(i,j)))
                pos(i,j)=1;
            else
                pos(i,j)=0;
            end
        end
        pos(i,:)=correct_sol(pos(i,:),bb);
    end
    cg_curve(l)=gBestScore;
end

end