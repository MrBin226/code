function Offspring = NSGA_Gen(MatingPool,Boundary,MaxOffspring)
% ����,���첢�����µ���Ⱥ
% ����: MatingPool,   �����, ����ÿ��i���͵�i+1�����彻����������Ӵ�, iΪ����
%       Boundary,     ���߿ռ�, ���һ��Ϊ�ռ���ÿά���Ͻ�, �ڶ���Ϊ�½�
%       MaxOffspring, ���ص��Ӵ���Ŀ, ��ȱʡ�򷵻����в������Ӵ�, ���ͽ���صĴ�С��ͬ
% ���: Offspring, �������Ӵ�����Ⱥ

    [N,D] = size(MatingPool);
    if nargin < 3 || MaxOffspring < 1 || MaxOffspring > N
        MaxOffspring = N;
    end
    
            %�Ŵ���������
            ProC = 1;       %�������
            ProM = 1/D;     %�������
            DisC = 20;   	%�������
            DisM = 20;   	%�������

            %ģ������ƽ���
            Offspring = zeros(N,D);
            for i = 1 : 2 : N
                beta = zeros(1,D);
                miu  = rand(1,D);
                beta(miu<=0.5) = (2*miu(miu<=0.5)).^(1/(DisC+1));
                beta(miu>0.5)  = (2-2*miu(miu>0.5)).^(-1/(DisC+1));
                beta = beta.*(-1).^randi([0,1],1,D);
                beta(rand(1,D)>ProC) = 1;
                Offspring(i,:)   = (MatingPool(i,:)+MatingPool(i+1,:))/2+beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
                Offspring(i+1,:) = (MatingPool(i,:)+MatingPool(i+1,:))/2-beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
            end
            Offspring = Offspring(1:MaxOffspring,:);

            %����ʽ����
            if MaxOffspring == 1
                MaxValue = Boundary(1,:);
                MinValue = Boundary(2,:);
            else
                MaxValue = repmat(Boundary(1,:),MaxOffspring,1);
                MinValue = repmat(Boundary(2,:),MaxOffspring,1);
            end
            k    = rand(MaxOffspring,D);%���ѡ��Ҫ����Ļ���λ
            miu  = rand(MaxOffspring,D);%���ö���ʽ����
            Temp = k<=ProM & miu<0.5;   %Ҫ����Ļ���λ
            Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(Offspring(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
            Temp = k<=ProM & miu>=0.5; 
            Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-Offspring(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));

            %Խ�紦��
            Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue); %�Ӵ�Խ�Ͻ紦��
            Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue); %�Ӵ�Խ�½紦��
end