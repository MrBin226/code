function [Top_predator_fit,Top_predator_pos,Convergence_curve]=MPA(SearchAgents_no,Max_iter,lb,ub,dim,fobj,I,w,net_struct)


Top_predator_pos=zeros(1,dim);
Top_predator_fit=inf; 

Convergence_curve=zeros(1,Max_iter);
stepsize=zeros(SearchAgents_no,dim);
fitness=inf(SearchAgents_no,1);


Prey=initialization(SearchAgents_no,dim,ub,lb);

% 混沌对立策略
alpha=0.7;
t0=rand();
new_Prey=zeros(size(Prey));
for i=1:SearchAgents_no
    if t0<alpha
        t=t0/alpha;
    else
        t=(1-t0)/(1-alpha);
    end
    t0=t;
    for j=1:dim
        new_Prey(i,j)=lb+ub-t*Prey(i,j);
    end
end
all_fit=zeros(2*SearchAgents_no,1);
all_Prey=[Prey;new_Prey];
for i=1:2*SearchAgents_no
    all_fit(i)=fobj(I,all_Prey(i,:),w,net_struct);
end
[~,idx]=sort(all_fit);
Prey=all_Prey(idx(1:SearchAgents_no),:);


Xmin=repmat(ones(1,dim).*lb,SearchAgents_no,1);
Xmax=repmat(ones(1,dim).*ub,SearchAgents_no,1);
         

Iter=0;
FADs=0.2;
P=0.5;

while Iter<Max_iter    
   
 for i=1:size(Prey,1)  
        
    Flag4ub=Prey(i,:)>ub;
    Flag4lb=Prey(i,:)<lb;    
    Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;                    
        
    fitness(i,1)=fobj(I,Prey(i,:),w,net_struct);
                     
     if fitness(i,1)<Top_predator_fit 
       Top_predator_fit=fitness(i,1); 
       Top_predator_pos=Prey(i,:);
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

 
     
 Elite=repmat(Top_predator_pos,SearchAgents_no,1); 
 CF=(1-Iter/Max_iter)^(2*Iter/Max_iter);
                             
 RL=0.05*levy(SearchAgents_no,dim,1.5);  
 RB=randn(SearchAgents_no,dim);      
           
  for i=1:size(Prey,1)
     for j=1:size(Prey,2)        
       R=rand();

       if Iter<Max_iter/3 
          stepsize(i,j)=RB(i,j)*(Elite(i,j)-RB(i,j)*Prey(i,j));                    
          Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j); 
             

       elseif Iter>Max_iter/3 && Iter<2*Max_iter/3 
          
         if i>size(Prey,1)/2
            stepsize(i,j)=RB(i,j)*(RB(i,j)*Elite(i,j)-Prey(i,j));
            Prey(i,j)=Elite(i,j)+P*CF*stepsize(i,j); 
         else
            stepsize(i,j)=RL(i,j)*(Elite(i,j)-RL(i,j)*Prey(i,j));                     
            Prey(i,j)=Prey(i,j)+P*R*stepsize(i,j);  
         end  
         

       else 
           
           stepsize(i,j)=RL(i,j)*(RL(i,j)*Elite(i,j)-Prey(i,j)); 
           Prey(i,j)=Elite(i,j)+P*CF*stepsize(i,j);  
    
       end  
      end                                         
  end    
        
      
  for i=1:size(Prey,1)  
        
    Flag4ub=Prey(i,:)>ub;  
    Flag4lb=Prey(i,:)<lb;  
    Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
  
    fitness(i,1)=fobj(I,Prey(i,:),w,net_struct);
        
      if fitness(i,1)<Top_predator_fit 
         Top_predator_fit=fitness(i,1);
         Top_predator_pos=Prey(i,:);
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

    % 自适应t分布
    for i=1:SearchAgents_no
        temp=Prey(i,:)+Prey(i,:).*trnd(Iter+1,1,dim);
        temp_fit=fobj(I,temp,w,net_struct);
        if fitness(i) >  temp_fit
            fitness(i)=temp_fit;
            Prey(i,:)=temp;
        end
    end
   % FADS                     
  if rand()<FADs
     U=rand(SearchAgents_no,dim)<FADs;                                                                                              
     Prey=Prey+CF*((Xmin+rand(SearchAgents_no,dim).*(Xmax-Xmin)).*U);

  else
     r=rand();  Rs=size(Prey,1);
     stepsize=(FADs*(1-r)+r)*(Prey(randperm(Rs),:)-Prey(randperm(Rs),:));
     Prey=Prey+stepsize;
  end
  
    for i=1:size(Prey,1)  

        Flag4ub=Prey(i,:)>ub;  
        Flag4lb=Prey(i,:)<lb;  
        Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;

        fitness(i,1)=fobj(I,Prey(i,:),w,net_struct);

          if fitness(i,1)<Top_predator_fit 
             Top_predator_fit=fitness(i,1);
             Top_predator_pos=Prey(i,:);
          end     
    end
  % 分组维度学习策略
  [sort_fitness,idx]=sort(fitness);
  elite_group=Prey(idx(1:floor(SearchAgents_no/2)),:);
  elite_group_fit=sort_fitness(1:floor(SearchAgents_no/2));
  study_group=Prey(idx(floor(SearchAgents_no/2)+1:end),:);
  study_group_fit=sort_fitness(floor(SearchAgents_no/2)+1:end);
  X_javg=mean(elite_group,1);
  H1=floor(dim/2);
  for i=1:size(study_group,1)
      X_delta=abs(study_group(i,:)-X_javg);
      [~,idx]=sort(X_delta,'descend');
      X_cross=study_group(i,:);
      for j=1:H1
         X_temp=X_cross;
         X_temp(idx(j))=X_javg(j);
         tt=fobj(I,X_temp,w,net_struct);
         if tt<study_group_fit(i)
             X_cross(idx(j))=X_javg(j);
         end
      end
      study_group(i,:)=X_cross;
  end
  H2=floor(dim/2);
  for i=1:size(elite_group,1)
      X_delta=abs(elite_group(i,:)-X_javg);
      [~,idx]=sort(X_delta,'descend');
      X_cross=elite_group(i,:);
      if i==1
          X_cross1=elite_group(end,:);
      else
          X_cross1=elite_group(i-1,:);
      end
      for j=1:H2
         X_temp=X_cross;
         X_temp(idx(j))=X_cross1(j);
         tt=fobj(I,X_temp,w,net_struct);
         if tt<elite_group_fit(i)
             X_cross(idx(j))=X_javg(j);
         end
      end
      elite_group(i,:)=X_cross;
  end
  Prey=[elite_group;study_group];
  
  
  Iter=Iter+1;  
  Convergence_curve(Iter)=Top_predator_fit; 
       
end

