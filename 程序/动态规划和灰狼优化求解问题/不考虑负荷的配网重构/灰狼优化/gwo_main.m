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
GreyWolves_num=25; %�ǵĸ���
MaxIt=50;   


[Alpha_score,Alpha_pos,Convergence_curve]=GWO(GreyWolves_num,MaxIt,lb,ub,nVar,fobj,con_charge,S_source,bb);

figure()
plot(1:MaxIt,Convergence_curve);
xlabel('��������')
ylabel('Ŀ�꺯��')
disp('�����������Ž����£�');
disp(['Ŀ�꺯��ֵΪ��' num2str(Alpha_score)]);
fprintf('(����%f������������%d)\n',powerflow(transform(Alpha_pos)),sum(xor(Alpha_pos,population1))-1);
%��������������
[openkg,closekg] = judge_kg(Alpha_pos,bb); %���������������Ҫ�ضϺͱպϵĿ���
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
disp(Alpha_pos);
toc;
