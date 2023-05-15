%������Ӧ��ֵ
%�����������Ⱥ
%�����������Ӧ��ֵ
function fitvalue = cal_fitvalue(pop,con_charge,S_source,bb,cost)
popsize=size(pop,1);             %��popsize������
population1=[1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,0]; %��ų�ʼ���ؼ�
for k=1:popsize
    S=transform(pop(k,:));       %�����������ת��Ϊ����Ŀ��غ�
    fitvalue1(k)=powerflow(S);      %�����״̬�µ�����
    if fitvalue1(k)<0 || fitvalue1(k)>0.08 || isnan(fitvalue1(k)) %��0��08���ų������н�
       fitvalue1(k)=0.08;
    else
        flag=[];
        [~,u,~]=powerflow_V(S);
        flag=[flag ~ismember(0,u<=1.05&u>=0.85)];
        [~,p,q,Iresult]=powerflow_S(S);
        Iresult(bb)=[];
         I = abs(Iresult);
        flag=[flag ~ismember(0,I<=1)];
        p(bb)=[];
        q(bb)=[];
        S1 = sum(p)+sum(con_charge(:,1))+sum(S_source(2:end,1));
        S2 = sum(q)+sum(con_charge(:,2))+sum(S_source(2:end,2));
        flag=[flag (S1+S_source(1,1)>=0 && S2+S_source(1,2)>=0)];
        
        if ismember(0,flag)
            fitvalue1(k)=0.08;
        end
    end
    %��0.08��ȥ���𣬱�֤����ԽС����Ӧ��ֵԽ��*10��Ϊ�˱�֤fitvalue1��fitvaule2�ӽ�һ��������
    fitvalue1(k)=(0.08-fitvalue1(k))*10;
    fitvalue2(k)=sum(xor(pop(k,:),population1))-1; %���㿪�ز���������-1����Ϊ�ų�����֧·�Ķ���
    fitvalue2(k)=1/fitvalue2(k);%��1��ȥ������������֤��������Խ�٣���Ӧ��ֵԽ��
    fitvalue(k)=0.1*fitvalue1(k)+0.2*fitvalue2(k)+0.7*cost/100; %������Ӧ�ȣ�����Ȩֵת���ɵ�Ŀ��
end
end
