function sequence = coupled_logistic_map(x, t)%coupled_logistic_map��������������8*8С����������еģ������������Ƕ�ά��
src=imread('lena.jpg');%��ȡlena.jpg���õ�ͼ�����
x=[0.34,0.75];
s = size(src);%�õ�src������������
t=(s(1)*s(2))/64;
x1 = x(1);
x2 = x(2);
mu1 = 2.93;
mu2 = 3.17;
gamma1 = 0.179;
gamma2 = 0.139;
sequence = zeros(2,t);%����һ��2��t�еľ��󣬾���Ԫ��ȫΪ0
sequence(1,1) = x1; %sequence����ĵ�1�е�1��Ԫ�ص���x1
sequence(2,1) = x2; %sequence����ĵ�2�е�1��Ԫ�ص���x1
for i=2:t %i��2��t����ȡֵ��i=2��3��4��5��...��t
    % sequence����ĵ�1�е�i��Ԫ�ص���mu1*sequence����ĵ�1�е�i-1��Ԫ��*��1-sequence����ĵ�1�е�i-1��Ԫ�أ�+gamma1*sequence����ĵ�2�е�i-1��Ԫ�ص�ƽ��
    % ���統i=2ʱ����Ϊsequence(1,1)=x1,sequence(2,1)=x2����ʱsequence(1,2)=mu1*x1*(1-x1)+gamma1*(x2)^2
    sequence(1,i) = mu1*sequence(1,i-1)*(1-sequence(1,i-1))+gamma1*sequence(2,i-1)^2;
    % ���統i=2ʱ����Ϊsequence(1,1)=x1,sequence(2,1)=x2����ʱsequence(2,2)=mu2*x2*(1-x2)+gamma2*(x1)^2+x1*x2
    sequence(2,i) = mu2*sequence(2,i-1)*(1-sequence(2,i-1))+gamma2*(sequence(1,i-1)^2+sequence(1,i-1)*sequence(2,i-1));
end