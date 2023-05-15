
function [Output,Boundary] = Objective(Operation,Problem,M,Input)
%input:N ��Ⱥ��ģ
    persistent K; %����־ñ���
    %�־ñ������������ǵĺ����ľֲ�������
    %����ֵ�����ڶԸú����ĸ��ε�����ʹ�õ��ڴ��С�
    
    Boundary = NaN;
    switch Operation  %ѡ�����ģʽ0/1
        
        %0����ʼ����Ⱥ
        case 0
            k = find(~isstrprop(Problem,'digit'),1,'last'); % �ж��м���Ӣ����ĸ��k =4
            %isstrprop:����ַ�ÿһ���ַ��Ƿ�����ָ���ķ�Χ,'digit'�ж��ǲ������֣�����0/1����
            %��~�� ��0/1����ȡ��
            K = [5 10 10 10 10];
            K = K(str2double(Problem(k+1:end))); %'DTZL2'K=10
            %str2double��һ�ֺ������书���ǰ��ַ���ת����ֵ��
            
            D = M+K-1; %D����������
            MaxValue   = ones(1,D);
            MinValue   = zeros(1,D);
            Population = rand(Input,D);   %ȷ����Ⱥ��С��(N*D)
            Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);
            % %�����µĳ�ʼ��Ⱥ
            Output   = Population;
            Boundary = [MaxValue;MinValue];
            
        %1������Ŀ�꺯��ֵ������ֻ����DTLZ1~DTZL4��������
        case 1
            Population    = Input;  %�Ѿ���ʼ����ɵ���Ⱥ
            FunctionValue = zeros(size(Population,1),M);
            switch Problem
                case 'DTLZ1'
                    g = 100*(K+sum((Population(:,M:end)-0.5).^2-cos(20.*pi.*(Population(:,M:end)-0.5)),2));
                    for i = 1 : M  %�����iάĿ�꺯��ֵ
                        FunctionValue(:,i) = 0.5.*prod(Population(:,1:M-i),2).*(1+g);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*(1-Population(:,M-i+1));
                        end
                    end
                case 'DTLZ2'
                    g = sum((Population(:,M:end)-0.5).^2,2);
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ3'
                    g = 100*(K+sum((Population(:,M:end)-0.5).^2-cos(20.*pi.*(Population(:,M:end)-0.5)),2));
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ4'
                    Population(:,1:M-1) = Population(:,1:M-1).^100;
                    g = sum((Population(:,M:end)-0.5).^2,2);
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ5'
                    g = sum((Population(:,M:end)-0.5).^2,2);
                    
                    for i = 1 : M
                        theta =(pi./(4*(1+g))).*(1+2.*g.*Population(:,1:M-i));
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*theta),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*(pi./(4*(1+g))).*(1+2.*g.*Population(:,M-i+1)));
                        end
                    end                  
            end
            Output = FunctionValue;
    end
end