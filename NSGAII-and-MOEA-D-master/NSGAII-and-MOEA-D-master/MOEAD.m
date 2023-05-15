function MOEAD(Problem,M)
clc;
format compact;%�ո����
tic;%��¼����ʱ�� 


%�����趨
Generations = 700; %��������
delta = 0.9;
nr = 2;
if M == 2
    N = 100;%��Ⱥ��ģ/Ȩ������
    H = 99;
else M == 3
    N = 105;
    H = 13;
end

    %��ʼ������
    Evaluations = Generations*N;
    Generations = floor(Evaluations/N);%floor����:�����������ȡ��
    [N,W] = EqualWeight(H,M);%��������Ȩ��  W:(N*3)
    W(W==0) = 0.000001;
    T = floor(N/10); %floor����:�����������ȡ��
    

    %�ھ��ж�
    B = zeros(N);
    for i = 1 : N-1
        for j = i+1 : N
            B(i,j) = norm(W(i,:)-W(j,:));%norm�����ؾ��������ֵsvd
            B(j,i) = B(i,j);
        end
    end
    [Bsort,B] = sort(B,2);
    %sort(A,dim)���Ծ����н����������򣬲����������ľ���
    %���ص�����BΪλ�õ�������Ϊ��Bͬ����С�ı�������.
    %ע�⣺B��Ϊ����λ�ã���������Ӧ����Ȩ���������ھӸ�����W������
    B = B(:,1:T);%ȡǰT��
    
    %��ʼ����Ⱥ��
    [Population,Boundary] = Objective(0,Problem,M,N);
    FunctionValue = Objective(1,Problem,M,Population);
    Z = min(FunctionValue);%��ʼ��Ŀ�꺯��fi������ֵ��

    %��ʼ����
    for Gene = 1 : Generations
        %��ÿ������ִ�в���
        for i = 1 : N
            %ѡ����ĸ
            if rand < delta  %delta = 0.9;
                P = B(i,:);%ȡ��i�е��ھ�����
            else
                P = 1:N;
            end
            k = randperm(length(P));%randperm��һ������������,��ű�����������
            
            %�����Ӵ�/����ʽ����
            %function Offspring = Gen(r1,r2,r3,Boundary)
            %r1:��i�е���Ⱥ��1*7��
            %r2,r3:����ѡ��������Ⱥ
            Offspring = Gen(Population(i,:),Population(P(k(1)),:),Population(P(k(2)),:),Boundary);
            OffFunValue = Objective(1,Problem,M,Offspring);

            %�������������
            Z = min(Z,OffFunValue);
            
            %����P�еĸ���
            c = 0;
            for j = randperm(length(P))%randperm��һ������������,��ű�����������
                if c >= nr
                    break;
                end
                g_old = max(abs(FunctionValue(P(j),:)-Z).*W(P(j),:));
                g_new = max(abs(OffFunValue-Z).*W(P(j),:));              
                if g_new < g_old
                    %���µ�ǰ�����ĸ���
                    Population(P(j),:) = Offspring;
                    FunctionValue(P(j),:) = OffFunValue;
                    c = c+1;
                end
            end

        end
        
        cla;%cla �ӵ�ǰ������ɾ�������ɼ����������ͼ�ζ���
        DrawGraph(FunctionValue);%�Ѻ���ֵ�ĵ㻭����ά����ϵ�
        hold on;%������֪Pareto������
        switch Problem
            case 'DTLZ1'
                if M == 2
                    pareto_x = linspace(0,0.5);
                    pareto_y = 0.5 - pareto_x;
                    plot(pareto_x, pareto_y, 'r');
                elseif M == 3
                    [pareto_x,pareto_y]  = meshgrid(linspace(0,0.5));
                    pareto_z = 0.5 - pareto_x - pareto_y;
                    axis([0,1,0,1,0,1]);
                    mesh(pareto_x, pareto_y, pareto_z);
                end
            otherwise
                if M == 2
                    pareto_x = linspace(0,1);
                    pareto_y = sqrt(1-pareto_x.^2);
                    plot(pareto_x, pareto_y, 'r');
                elseif M == 3
                    [pareto_x,pareto_y,pareto_z] =sphere(50);
                    axis([0,1,0,1,0,1]);
                    mesh(1*pareto_x,1*pareto_y,1*pareto_z);
                end
        end
        pause(0.01);
        %clc;
    end
end