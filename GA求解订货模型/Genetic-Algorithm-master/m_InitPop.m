function pop=m_InitPop(numpop,r_min,r_max,q_min,q_max)
%% ��ʼ����Ⱥ
%  ���룺numpop--��Ⱥ��С��
%     [r_min,r_max,q_min,q_max]--��ʼ��Ⱥ���ڵ�����
pop=zeros(2,numpop);
%rand�ǲ���һ��(0,1)�������
pop(1,:)=round(rand(1,numpop)*(r_max-r_min)) + r_min;
pop(2,:)=round(rand(1,numpop)*(q_max-q_min)) + q_min;
    