function [Alpha_score,Alpha_pos,Convergence_curve]=GWO(SearchAgents_no,Max_iter,lb,ub,dim,fobj,con_charge,S_source,bb,cost)

Alpha_pos=zeros(1,dim);
Alpha_score=-inf; 

Beta_pos=zeros(1,dim);
Beta_score=-inf;

Delta_pos=zeros(1,dim);
Delta_score=-inf;


Positions=initialization(SearchAgents_no,bb);

Convergence_curve=zeros(1,Max_iter);

l=0;


while l<Max_iter
    for i=1:size(Positions,1)  
        
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;               
        
        fitness=fobj(Positions(i,:),con_charge,S_source,bb,cost);
        
        if fitness>Alpha_score 
            Alpha_score=fitness; 
            Alpha_pos=Positions(i,:);
        end
        
        if fitness<Alpha_score && fitness>Beta_score 
            Beta_score=fitness; 
            Beta_pos=Positions(i,:);
        end
        
        if fitness<Alpha_score && fitness<Beta_score && fitness>Delta_score 
            Delta_score=fitness;
            Delta_pos=Positions(i,:);
        end
    end
    
    
    a=2-l*((2)/Max_iter); 
    

    for i=1:size(Positions,1)
        c=2.*rand(1, dim);
        D=abs(c.*Delta_pos-Positions(i,:));
        A=2.*a.*rand(1, dim)-a;
        X1=Delta_pos-A.*abs(D);
        
        c=2.*rand(1, dim);
        D=abs(c.*Beta_pos-Positions(i,:));
        A=2.*a.*rand()-a;
        X2=Beta_pos-A.*abs(D);
        
        c=2.*rand(1, dim);
        D=abs(c.*Alpha_pos-Positions(i,:));
        A=2.*a.*rand()-a;
        X3=Alpha_pos-A.*abs(D);

        tt=1./(1+exp(-5*((X1+X2+X3)./3)));
        temp=zeros(1,dim);
        temp(tt>=rand())=1;
        Positions(i,:)=correct_sol(temp,bb);
    end
    l=l+1;    
    Convergence_curve(l)=Alpha_score;
end



