function binPop=m_Coding(pop,pop_length,r_min,r_max,q_min,q_max)
%% �����Ʊ��루����Ⱦɫ�壩
% ���룺pop--��Ⱥ
%      pop_length--���볤��
%      r_min,q_min--r��Q����Сֵ

%��ʮ��������ȥ��Сֵ����Ϊһ��Ⱦɫ�����ȡ��0�����Լ�ȥ��Сֵ�����ڱ���
pop(1,:) = round((2^pop_length(1)-1)*(pop(1,:)-r_min)/(r_max-r_min));
pop(2,:) = round((2^pop_length(2)-1)*(pop(2,:)-q_min)/(q_max-q_min));

for n=1:size(pop,2) %��ѭ��
    for k=1:size(pop,1) %��ѭ��
        dec2binpop{k,n}=dec2bin(pop(k,n));%dec2bin�����Ϊ�ַ�������
                                          %dec2binpop��cell����
        lengthpop=length(dec2binpop{k,n});
        for s=1:pop_length(k)-lengthpop %����
            dec2binpop{k,n}=['0' dec2binpop{k,n}];
        end
    end
    s=[];
    %��r��Q�ĸ����������һ������r=10001,Q=0011,����Ϻ�Ϊ100010011
    for d=1:size(pop,1)
        s=[s,bin2gray(dec2binpop{d,n})];
    end

    binPop{n}=s;
end

    