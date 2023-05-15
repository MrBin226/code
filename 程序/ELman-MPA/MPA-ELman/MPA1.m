function [Top_predator_fit,Top_predator_pos,Convergence_curve,BestNet]=MPA1(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

net = {};
Top_predator_pos=zeros(1,dim);
Top_predator_fit=inf; 

Convergence_curve=zeros(1,Max_iter);
stepsize=zeros(SearchAgents_no,dim);
fitness=inf(SearchAgents_no,1);

Xmin=repmat(ones(1,dim).*lb,SearchAgents_no,1);
Xmax=repmat(ones(1,dim).*ub,SearchAgents_no,1);
Prey=initialization1(SearchAgents_no,dim,ub,lb);
  

Iter=0;
FADs=0.2;
P=0.5;
f=0;
F0=0.5;
CR=0.9;
while Iter<Max_iter    
 for i=1:SearchAgents_no
    r1=rand();
    r2=rand();
    m=(Xmin(1,:)+Xmax(1,:))/2;
    for j=1:dim
        if Prey(i,j)<m(j)
            temp(j)=m(j)+(m(j)-Prey(i,j))*r1;
        else
            temp(j)=m(j)-(Prey(i,j)-m(j))*r2;
        end
    end
    f1=fobj(Prey(i,:));
    f2=fobj(temp);
    if f2<f1
        Prey(i,:)=temp;
    end
end
 for i=1:size(Prey,1)  
        
    Flag4ub=Prey(i,:)>ub;
    Flag4lb=Prey(i,:)<lb;    
    Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;                    
        
    [fitness(i,1),net{i}]=fobj(Prey(i,:));
                     
     if fitness(i,1)<Top_predator_fit 
       Top_predator_fit=fitness(i,1); 
       Top_predator_pos=Prey(i,:);
        BestNet=net{i};
     end          
 end
     
    
%  if Iter==0
%    fit_old=fitness;    Prey_old=Prey;
%  end
%      
%   Inx=(fit_old<fitness);
%   Indx=repmat(Inx,1,dim);
%   Prey=Indx.*Prey_old+~Indx.*Prey;
%   fitness=Inx.*fit_old+~Inx.*fitness;
%         
%   fit_old=fitness;    Prey_old=Prey;
  
     
 Elite1=repmat(Top_predator_pos,SearchAgents_no,1);
 CF=(1-Iter/Max_iter)^(2*Iter/Max_iter);
                        
 RL=0.05*levy(SearchAgents_no,dim,1.5);  
 RB=randn(SearchAgents_no,dim);
 
  for i=1:size(Prey,1)
     for j=1:size(Prey,2)        
       R=rand();
          %------------------第一阶段 ------------------- 
       if Iter<Max_iter/3 
          stepsize(i,j)=RB(i,j)*(Elite1(i,j)-RB(i,j)*Prey(i,j)); 
          Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j); 
             
          %---------------第二阶段----------------
      elseif Iter>Max_iter/3 && Iter<2*Max_iter/3 
         if i>size(Prey,1)/2
            stepsize(i,j)=RB(i,j)*(RB(i,j)*Elite1(i,j)-Prey(i,j));
            Prey(i,j)=Elite1(i,j)+P*CF*stepsize(i,j); 
            
         else
            stepsize(i,j)=RL(i,j)*(Elite1(i,j)-RL(i,j)*Prey(i,j));   
            Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j);  
         end 
        

         
         %----------------- 第三阶段-------------------
      else 
           stepsize(i,j)=RL(i,j)*(RL(i,j)*Elite1(i,j)-Prey(i,j)); 
           Prey(i,j)=Elite1(i,j)+P*CF*stepsize(i,j);  
       end 
     end
     
     %差分操作
     fit=fobj(Prey(i,:));
     if Iter>Max_iter/2 && f>=2 && fit>=Top_predator_fit
         F=F0*2^(exp(1-Max_iter / (Max_iter + 1 - Iter)));
         tt=randperm(SearchAgents_no,3);
         v=Prey(tt(1),:)+F*(Prey(tt(2),:)-Prey(tt(3),:));
         rn=randperm(dim,1);
         u=ones(1,dim);
         for l=1:dim
             if rand()<CR || l==rn
                 u(l)=v(l);
             else
                 u(l)=Prey(i,l);
             end
         end
         ff=fobj(u);
         if ff<fit
             Prey(i,:)=u;
         end
         f=0;
     end
      f=f+1;
  end    
        
          
  for i=1:size(Prey,1)  
        
    Flag4ub=Prey(i,:)>ub;  
    Flag4lb=Prey(i,:)<lb;  
    Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
  
    [fitness(i,1),net{i}]=fobj(Prey(i,:));
        
      if fitness(i,1)<Top_predator_fit 
         Top_predator_fit=fitness(i,1);
         Top_predator_pos=Prey(i,:);
          BestNet=net{i};
      end     
  end
        
    
    
 if Iter==0
    fit_old=fitness;    Prey_old=Prey;
 end
     
    Inx=(fit_old<fitness);
    Indx=repmat(Inx,1,dim);
    Prey=Indx.*Prey_old+~Indx.*Prey;
    fitness=Inx.*fit_old+~Inx.*fitness;
        
    fit_old=fitness;    Prey_old=Prey;

     
                             
  if rand()<FADs
     U=rand(SearchAgents_no,dim)<FADs;                                                                                              
     Prey=Prey+CF*((Xmin+rand(SearchAgents_no,dim).*(Xmax-Xmin)).*U);

  else
     r=rand();  Rs=size(Prey,1);
     stepsize=(FADs*(1-r)+r)*(Prey(randperm(Rs),:)-Prey(randperm(Rs),:));
     Prey=Prey+stepsize;
  end
                                                        
  Iter=Iter+1;  
  Convergence_curve(Iter)=Top_predator_fit; 

%     disp(Iter);
       
end

