function [FrontValue,MaxFront] = NonDominateSort(FunctionValue,Operation)
% ���з�֧������
% ����: FunctionValue, ���������Ⱥ(Ŀ��ռ�)����Ŀ�꺯��
%       Operation,     ��ָ���������һ����,����ǰһ�����,�����������еĸ���, Ĭ��Ϊ�������еĸ���
% ���: FrontValue, ������ÿ���������ڵ�ǰ������, δ����ĸ���ǰ������Ϊinf
%       MaxFront,   ��������ǰ����

    if Operation == 1
        Kind = 2; 
    else
        Kind = 1;  %��
    end
	[N,M] = size(FunctionValue);
    
    MaxFront = 0;
    cz = zeros(1,N);  %%��¼�����Ƿ��ѱ�������
    FrontValue = zeros(1,N)+inf; %ÿ�������ǰ������
    [FunctionValue,Rank] = sortrows(FunctionValue);
    %sortrows����С�������еķ�ʽ�������򣬷����������ͼ�����������(����ض�����)��ԭʼ�����е�����
    
    %��ʼ�����ж�ÿ�������ǰ����
    while (Kind==1 && sum(cz)<N) || (Kind==2 && sum(cz)<N/2) || (Kind==3 && MaxFront<1)
        MaxFront = MaxFront+1;
        d = cz;
        for i = 1 : N
            if ~d(i)
                for j = i+1 : N
                    if ~d(j)
                        k = 1;
                        for m = 2 : M
                            if FunctionValue(i,m) > FunctionValue(j,m)  %�ȽϺ���ֵ���жϸ����֧���ϵ
                                k = 0;
                                break;
                            end
                        end
                        if k == 1
                            d(j) = 1;
                        end
                    end
                end
                FrontValue(Rank(i)) = MaxFront;
                cz(i) = 1;
            end
        end
    end
end


%% ��֧������α����
% def fast_nondominated_sort( P ):
% F = [ ]
% for p in P:
% Sp = [ ] #��¼������p֧��ĸ���
% np = 0  #֧�����p�ĸ���
% for q in P:
% if p > q:                #���p֧��q����q��ӵ�Sp�б���
% Sp.append( q )  #������p֧��ĸ���
% else if p < q:        #���p��q֧�䣬���np��1
% np += 1  #֧�����p�ĸ���
% if np == 0:
% p_rank = 1        #����ø����npΪ0����ø���ΪPareto��һ��
% F1.append( p )
% F.append( F1 )
% i = 0
% while F[i]:
% Q = [ ]
% for p in F[i]:
% for q in Sp:        #��������Sp�����еĸ����������
% nq -= 1
% if nq == 0:     #����ø����֧�����Ϊ0����ø����Ƿ�֧�����
% q_rank = i+2    #�ø���Pareto����Ϊ��ǰ��߼����1����ʱi��ʼֵΪ0������Ҫ��2
% Q.append( q )
% F.append( Q )
% i += 1
