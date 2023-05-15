clear all
clc
warning('off');
tic;
drawing_flag = 1;
p_energy_max=200;
q_energy_max=150;
% device=[180.43,120.06;80,26.29;100,32.87;160,52.59];%���豸���й��������޹�����,��һ������
device=[180.43,120.06;100,32.87;100,48.43;160,52.59];%���豸���й��������޹�����,��һ������
charge_seq=[1,2,3,4,5,6,7];%��������
interrupt_charge=[3,4,5,6,7];%�ɶϸ���
charge=[-100,-32.87;-80,-38.75;-80,-38.75;-60,-19.72;-100,-32.87;-60,-19.72;-130,-62.96];%�����ɵ��й��������޹�����
P_max=sum(device(:,1))+sum(charge(setdiff(charge_seq,interrupt_charge),1));
Q_max=sum(device(:,2))+sum(charge(setdiff(charge_seq,interrupt_charge),2));

con_charge = charge;%���ӵĸ��ɵ��й��������޹�����
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
N=25; %���Ӹ���
MaxIt=50;   

[gBest,cg_curve]=PSO(N,MaxIt,lb,ub,nVar,fobj,con_charge,S_source,bb);

figure(1)
plot(1:MaxIt,cg_curve);
xlabel('��������')
ylabel('Ŀ�꺯��')
disp('�����������Ž����£�');
disp(['Ŀ�꺯��ֵΪ��' num2str(cg_curve(end))]);
fprintf('(����%f������������%d)\n',powerflow(transform(gBest)),sum(xor(gBest,population1))-1);
%��������������
[openkg,closekg] = judge_kg(gBest,bb); %���������������Ҫ�ضϺͱպϵĿ���
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
disp(gBest);
toc;
