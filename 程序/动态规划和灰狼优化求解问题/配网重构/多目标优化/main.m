clear all
clc
tic;
warning('off');
drawing_flag = 1;
p_energy_max=200;
q_energy_max=150;
% device=[180.43,120.06;80,26.29;100,32.87;160,52.59];%���豸���й��������޹�����,��һ������
device=[180.43,120.06;100,32.87;100,48.43;160,52.59];%���豸���й��������޹�����,��һ������
charge_seq=[1,2,3,4,5,6,7];%��������
interrupt_charge=[3,4,5,6,7];%�ɶϸ���
c=[3,2,2,1,1];%�ɶϸ��ɵ��⳥�۸�
charge=[-100,-32.87;-80,-38.75;-80,-38.75;-60,-19.72;-100,-32.87;-60,-19.72;-130,-62.96];%�����ɵ��й��������޹�����
P_max=sum(device(:,1))+sum(charge(setdiff(charge_seq,interrupt_charge),1));
Q_max=sum(device(:,2))+sum(charge(setdiff(charge_seq,interrupt_charge),2));
weight_value=charge(interrupt_charge,:)*-1;

[max_value, decision_result] = dynamic_program([weight_value(:,1) weight_value(:,2)*100], [P_max,Q_max*100],c); %��100�Ǳ�Ϊ���������ڶ�̬�滮����
con_charge = charge(setdiff(charge_seq,interrupt_charge(decision_result==0)),:);%���ӵĸ��ɵ��й��������޹�����
S_source=[p_energy_max,q_energy_max;device(2:end,:)];%΢��������΢Դ�����ĸ�����
%��ų�ʼ���ؼ�(�����������)
population1=[1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,0];
%ȷ������֧·
bb=[24];
nVar=36;%��������
fobj=@cal_fitvalue;
% Lower bound and upper bound   %���޺�����
lb=0; %����  
ub=1; %����
GreyWolves_num=50; %�ǵĸ���
MaxIt=100; 
Archive_size=10; 
VarSize=[1 nVar];  
alpha=0.1; 
nGrid=10 ; 
beta=4;   
gamma=2;    

%%Initialization  ��ʼ��
GreyWolves=CreateEmptyParticle(GreyWolves_num);
Grey = initialization(GreyWolves_num ,bb);

for i=1:GreyWolves_num    %�ǵĸ���
    GreyWolves(i).Velocity=0;
    GreyWolves(i).Position=Grey(i,:);   %����ÿͷ�ǳ�ʼֵ
    GreyWolves(i).Cost=fobj(GreyWolves(i).Position,con_charge,S_source,bb);    %������е�Ŀ��ֵ
    if GreyWolves(i).Cost(1)==0
        GreyWolves(i).Cost(2)=GreyWolves(i).Cost(2)+10;
    end
    GreyWolves(i).Best.Position=GreyWolves(i).Position;   %��ÿ����ʼ�����Ϊ���Ž�
    GreyWolves(i).Best.Cost=GreyWolves(i).Cost;           %��Ŀ��ֵ����Ϊ���Ž�
end

GreyWolves=DetermineDomination(GreyWolves);

Archive=GetNonDominatedParticles(GreyWolves);

Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alpha);

for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end
%��λ����
pc = 0.7;
%�������
pm = 0.1;
%% ��ѭ��

for it=1:MaxIt       %ѭ��������������
    a=2-it*((2)/MaxIt);   %������Ϊ  aֵ�󣬴ٽ�ȫ������  aֵС�����оֲ�����
    for i=1:GreyWolves_num   %ѭ�����ǵ�������
        
        clear rep2 
        clear rep3
        
        Delta=SelectLeader(Archive,beta);
        Beta=SelectLeader(Archive,beta);
        Alpha=SelectLeader(Archive,beta);
        
        if size(Archive,1)>1
            counter=0;
            for newi=1:size(Archive,1)
                if sum(Delta.Position~=Archive(newi).Position)~=0
                    counter=counter+1;
                    rep2(counter,1)=Archive(newi);
                end
            end
            if exist('rep2')
                Beta=SelectLeader(rep2,beta);
            end
        end
        
        if size(Archive,1)>2
            counter=0;
            if exist('rep2')
                for newi=1:size(rep2,1)
                    if sum(Beta.Position~=rep2(newi).Position)~=0
                        counter=counter+1;
                        rep3(counter,1)=rep2(newi);  
                    end
                end
            end
            if exist('rep3')
                Alpha=SelectLeader(rep3,beta);
            end
        end
        

        c=2.*rand(1, nVar);
        D=abs(c.*Delta.Position-GreyWolves(i).Position);
        A=2.*a.*rand(1, nVar)-a;
        X1=Delta.Position-A.*abs(D);
        
        c=2.*rand(1, nVar);
        D=abs(c.*Beta.Position-GreyWolves(i).Position);
        A=2.*a.*rand()-a;
        X2=Beta.Position-A.*abs(D);
        
        c=2.*rand(1, nVar);
        D=abs(c.*Alpha.Position-GreyWolves(i).Position);
        A=2.*a.*rand()-a;
        X3=Alpha.Position-A.*abs(D);

        tt=1./(1+exp(-5*((X1+X2+X3)./3)));
        temp=zeros(1,nVar);
        temp(tt>=rand())=1;
        GreyWolves(i).Position=correct_sol(temp,bb);
        
        GreyWolves(i).Position=min(max(GreyWolves(i).Position,lb),ub); %�鿴�����Ƿ��ڷ�Χ��
        
%         GreyWolves(i).Cost=fobj(GreyWolves(i).Position);
    end
    newpop = cat(1,GreyWolves.Position);
    newpop = moveposition(newpop,pc,bb);
    newpop = mutation(newpop,pm,bb);
    for i=1:GreyWolves_num    %�ǵĸ���
        GreyWolves(i).Position=newpop(i,:);   %����ÿͷ�ǳ�ʼֵ
        GreyWolves(i).Cost=fobj(GreyWolves(i).Position,con_charge,S_source,bb);    %������е�Ŀ��ֵ
        if GreyWolves(i).Cost(1)==0
            GreyWolves(i).Cost(2)=GreyWolves(i).Cost(2)+10;
        end
    end
    
    GreyWolves=DetermineDomination(GreyWolves);
    non_dominated_wolves=GetNonDominatedParticles(GreyWolves);
    
    Archive=[Archive
        non_dominated_wolves];
    
    Archive=DetermineDomination(Archive);
    Archive=GetNonDominatedParticles(Archive);
    
    for i=1:numel(Archive)
        [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end
    
    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gamma);
        
        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,alpha);
        
    end
    
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    
    costs=GetCosts(GreyWolves);        %���еĽ� 
    Archive_costs=GetCosts(Archive);   %���еķ�֧���
    
    if drawing_flag==1
        hold off
        plot(costs(1,:),costs(2,:),'k.');
        hold on
        plot(Archive_costs(1,:),Archive_costs(2,:),'rd');
        legend('Grey wolves','Non-dominated solutions');
        drawnow    %ˢ����Ļ
    end
    
end
disp('�����н����£�');
for i=1:length(Archive)
    pop(i,:)=Archive(i).Position;
end
disp('�Ͽ��Ŀɶϸ���Ϊ��');
disp(interrupt_charge(decision_result==0));
pop=unique(pop,'rows');
% obj_value=fobj(pop,con_charge,S_source,bb);
for i=1:size(pop,1)
    fprintf('��%d����(����%f������������%d)\n',i,powerflow(transform(pop(i,:))),sum(xor(pop(i,:),population1))-1);
    %��������������
    [openkg,closekg] = judge_kg(pop(i,:),bb); %���������������Ҫ�ضϺͱպϵĿ���
    fprintf('�����������:');
    fprintf('���򿪣�');
    for j=1:length(openkg)
        fprintf('%d ',openkg(j));
    end
    fprintf('���رգ�');
    for j=1:length(closekg)
        fprintf('%d ',closekg(j));
    end
    fprintf('\n');
    disp(pop(i,:));
    
end
toc;
