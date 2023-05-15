function [branch ,branch_P ,branch_Q, Iresult]=powerflow_S(S)
format long
%S=[7,11,14,28,32];
%S=[33,34,35,36,37];
zhilu=ones(1,37);
for k=1:37            
    if k==S(1)
       zhilu(k)=0;
    end
    if k==S(2)
       zhilu(k)=0;
    end
    if k==S(3)
       zhilu(k)=0;
    end
    if k==S(4)
       zhilu(k)=0;
    end
    if k==S(5)
       zhilu(k)=0;
    end
end
Branch_data = [
    0   1   0.0922  0.0470;
    1   2   0.4930  0.2511;
    2   3   0.3660  0.1864;
    3   4   0.3811  0.1941;
    4   5   0.8190  0.7070;
    5   6   0.1872  0.6188;
    6   7   0.7114  0.2351;
    7   8   1.0300  0.7400;
    8   9  1.0440  0.7400;
    9   10  0.1966  0.0650;
    10  11  0.3744  0.1238;
    11  12  1.4680  1.1550;
    12  13  0.5416  0.7129;
    13  14  0.5910  0.5260;
    14  15  0.7463  0.5450;
    15  16  1.2890  1.7210;
    16  17  0.7320  0.5740;
    1   18  0.1640  0.1565;
    18  19  1.5042  1.3554;
    19  20  0.4095  0.4784;
    20  21  0.7089  0.9373;
    2   22  0.4512  0.3083;
    22  23  0.8980  0.7091;
    23  24  0.8960  0.7011;
    5   25  0.2030  0.1034;
    25  26  0.2842  0.1447;
    26  27  1.0590  0.9337;
    27  28  0.8042  0.7006;
    28  29  0.5075  0.2585;
    29  30  0.9744  0.9630;
    30  31  0.3105  0.3619;
    31  32  0.3410  0.5302;
    7   20  2       2;
    8   14  2       2;
    11  21  2       2;
    17  32  0.5     0.5;
    24  28  0.5     0.5;
];                                     % ֧·���迹
Nodedata = [
    0   0       0;
    1   100.00  60.00;
    2   90.00   40.00;
    3   120.00  80.00;
    4   60.00   30.00;
    5   60.00   20.00;
    6   200.00  100.00;
    7   200.00  100.00;
    8   60.00   20.00;
    9  60.00   20.00;
    10  45.00   30.00;
    11  60.00   35.00;
    12  60.00   35.00;
    13  120.00  80.00;
    14  60.00   10.00;
    15  60.00   20.00;
    16  60.00   20.00;
    17  90.00   40.00;
    18  90.00   40.00;
    19  90.00   40.00;
    20  90.00   40.00;
    21  90.00   40.00;
    22  90.00   50.00;
    23  420.00  200.00;
    24  420.00  200.00;
    25  60.00   25.00;
    26  60.00   25.00;
    27  60.00   20.00;
    28  120.00  70.00;
    29  200.00  600.00;
    30  150.00  70.00;
    31  210.00  100.00;
    32  60.00   40.00;
];                                      % �ڵ㣬����
UB = 12.66;                             % ��ѹ��׼ kV
SB = 10;                                % ���ʻ�׼ MVA
ZB = UB^2/SB;                           % �迹��׼ ohm
A=zeros(37,4);
A(:,[3,4]) = Branch_data(:,[3,4]) / ZB;     % �迹���ۻ�
A(:,[1,2]) = Branch_data(:,[1,2]);          % �迹���ۻ������
Bus=ones(33,3);
Bus(:,[2,3]) = Nodedata(:,[2,3]) / SB / 1000;% ���ʱ��ۻ�(������KVA����׼ֵ��MVA)
%p,q��Ÿ��ڵ�ע�빦��
p = -Bus(:,2);           % ע�빦��Ϊ��
q = -Bus(:,3);
%���ݡ�����ϵͳ��������6ҳ�ṩ�ķ����γɽڵ㵼�ɾ���
Y=zeros(33,33);
for k=1:37
    if zhilu(k)==1
        m=A(k,1)+1;
        n=A(k,2)+1;
        Y(m,m)=Y(m,m)+1/(A(k,3)+i*A(k,4));
        Y(n,n)=Y(n,n)+1/(A(k,3)+i*A(k,4));
        Y(m,n)=Y(m,n)-1/(A(k,3)+i*A(k,4));
        Y(n,m)=Y(n,m)-1/(A(k,3)+i*A(k,4));
    end
end 
%����G��B����
G=real(Y);
B=imag(Y);
%��ʼ�����ڵ�delt,u
delt=zeros(1,33);
u=ones(1,33);
%��ʼ��������k�����㾫��precision
k=0;
precision=1;
%������
while precision>0.0001 && k<10
    %����delt P
    for m=2:33
        for n=1:33
            pt(n)=u(m)*u(n)*(G(m,n)*cos(delt(m)-delt(n))+B(m,n)*sin(delt(m)-delt(n)));
        end
        pp(m-1)=p(m)-sum(pt);
    end
    %����delt Q
    for m=2:33
        for n=1:33
            qt(n)=u(m)*u(n)*(G(m,n)*sin(delt(m)-delt(n))-B(m,n)*cos(delt(m)-delt(n)));
        end
        qq(m-1)=q(m)-sum(qt);
    end
    %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е�[delt P,delt Q]
    for m=1:64
        if (m<33)
        PQ(m)=pp(m);     
        else
        PQ(m)=qq(m-32);
        end
    end
    %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е�H�Ӿ���ǶԽ���Ԫ��
    for m=2:33
        for n=2:33
            if m==n
            else
                H(m-1,n-1)=-u(m)*u(n)*(G(m,n)*sin(delt(m)-delt(n))-B(m,n)*cos(delt(m)-delt(n)));
            end
        end
    end
    %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е�H�Ӿ���Խ���Ԫ��
    for m=2:33
        for n=1:33
            h(n)=u(m)*u(n)*(G(m,n)*sin(delt(m)-delt(n))-B(m,n)*cos(delt(m)-delt(n)));
        end
        H(m-1,m-1)=sum(h)+u(m)*u(m)*B(m,m);
    end
    %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е�M�Ӿ���ǶԽ���Ԫ��
    for m=2:33
        for n=2:33
            if m==n
            else
                M(m-1,n-1)=u(m)*u(n)*(G(m,n)*cos(delt(m)-delt(n))+B(m,n)*sin(delt(m)-delt(n)));
            end
        end
    end
    %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е�M�Ӿ���Խ���Ԫ��
    for m=2:33
        for n=1:33
            mm(n)=u(m)*u(n)*(G(m,n)*cos(delt(m)-delt(n))+B(m,n)*sin(delt(m)-delt(n)));
        end
        M(m-1,m-1)=u(m)*u(m)*G(m,m)-sum(mm);
    end
    %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е�N�Ӿ���ǶԽ���Ԫ��
    for m=2:33
        for n=2:33
            if m==n
            else
                N(m-1,n-1)=-u(m)*u(n)*(G(m,n)*cos(delt(m)-delt(n))+B(m,n)*sin(delt(m)-delt(n)));
            end
        end
    end
    %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е�N�Ӿ���Խ���Ԫ��
    for m=2:33
        for n=1:33
            nn(n)=u(m)*u(n)*(G(m,n)*cos(delt(m)-delt(n))+B(m,n)*sin(delt(m)-delt(n)));
        end
        N(m-1,m-1)=-u(m)*u(m)*G(m,m)-sum(nn);
    end
   %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е�L�Ӿ���ǶԽ���Ԫ��
    for m=2:33
        for n=2:33
            if m==n
            else
                L(m-1,n-1)=-u(m)*u(n)*(G(m,n)*sin(delt(m)-delt(n))-B(m,n)*cos(delt(m)-delt(n)));
            end
        end
    end
    %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е�L�Ӿ���Խ���Ԫ��
    for m=2:33
        for n=1:33
            l(n)=u(m)*u(n)*(G(m,n)*sin(delt(m)-delt(n))-B(m,n)*cos(delt(m)-delt(n)));
        end
        L(m-1,m-1)=u(m)*u(m)*B(m,m)-sum(l);
    end
   %���ɡ�����ϵͳ��������17ҳʽ(2-23)�е��Ÿ��Ⱦ���J
    for m=1:64
        for n=1:64
            if(m<33) & (n<33)
                J(m,n)=H(m,n);
            end
            if(m<33)&(n>32)
                J(m,n)=N(m,n-32);
            end
            if(m>32) & (n>32)
                J(m,n)=L(m-32,n-32);
            end
            if(m>32)&(n<33)
                J(m,n)=M(m-32,n);
            end
        end
    end
    %����[delt theta,delt u]
    uu=-inv(J)*PQ';
    %���㾫��
    precision=max(abs(uu));
    %�޸ĸ��ڵ�delt��u
    for m=1:32
        delt(m+1)=delt(m+1)+uu(m);
    end
    for m=1:32
        u(m+1)=u(m+1)+uu(m+32);
    end
    %�޸ļ�����
    k=k+1;
end
%����1�ڵ��й����޹���2��3�ڵ��޹�
for m=1:33
    p0(m)=u(1)*u(m)*(G(1,m)*cos(delt(1)-delt(m))+B(1,m)*sin(delt(1)-delt(m)));
end
p(1)=sum(p0);
for n=1:33
    q0(n)=u(1)*u(n)*(G(1,n)*sin(delt(1)-delt(n))-B(1,n)*cos(delt(1)-delt(n)));
end
q(1)=sum(q0);
%������
%����֧·������֧·����
I=zeros(1,37);
branch_S=zeros(1,37);
for k=1:37
    if zhilu(k)==1
          I(k)=(u(A(k,1)+1)-u(A(k,2)+1))*(1/(A(k,3)+A(k,4)*1i));  %�������
          branch_S(k)=u(A(k,1)+1)*conj(I(k));
    end
end 
%�����֧·�����볱��
Iresult=I;
branch=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37];
branch_P=real(branch_S);
branch_Q=imag(branch_S);
end
