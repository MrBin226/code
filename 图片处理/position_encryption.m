function dst =position_encryption(src)
% src=imread('lena.jpg');%��ȡlena.jpg���õ�һ��ͼ�����
s = size(src);%��ȡsrc������������,s(1)��ʾ������s(2)��ʾ����
e1 = mod(s(1),8);%mod()�����ຯ����mod(s(1),8)��ʾs(1)��8ȡ��
s1 = floor(s(1)/8);%s(1)/8�Ľ��������ȡ��
if e1 %���s(1)����8�ı���
    d1 = ones(1,s1+1);%����һ��1��s1+1�еľ��󣬾���Ԫ��ȫΪ1
    d1 = 8*d1;%�õ�һ��1��s1+1�еľ��󣬾���Ԫ��ȫΪ8
    d1(s1+1) = e1;%��d1�ĵ�1�У���s1+1�е�Ԫ�ص���e1
else %���s(1)��8�ı���
    d1 = ones(1,s1);
    d1 = 8*d1;
end
e2 = mod(s(2),8);%mod(s(2),8)��ʾs(2)��8ȡ��
s2 = floor(s(2)/8);
if e2 %���s(2)����8�ı���
    d2 = ones(1,s2+1);
    d2 = 8*d2;
    d2(s2+1) = e2;
else %���s(2)��8�ı���
    d2 = ones(1,s2);
    d2 = 8*d2;
end
%����coupled_logistic_map����
sequence = coupled_logistic_map([0.062,0.284], length(d1)*length(d2)); % length(d1)*length(d2)��ʾd1������*d2������
[y,key] = sort(sequence(2,:));%sort(sequence(2,:))��ʾ�Ծ���sequence�ĵ�2�н��д�С��������,y��ʾ����Ľ��,key��ʾ������Ԫ����ԭ�������е�λ��
% ����a=[3,2,1],[b,c]=sort(a); ��b=[1,2,3],c=[3,2,1]������c�ĵ�һ��Ԫ�ر�ʾb�еĵ�һ��Ԫ����a�е�λ��Ϊ3
if(length(s)>2) %���s�е�Ԫ�ش���2������ʾlena.jpg��һ�Ų�ɫͼƬ������άͼ��
    s3 = s(3); %��ȡͼƬ��ͨ��������3
    cell_src = mat2cell(src,d1,d2,s3); %��ʾ��src��������d1��d2��s3�߶Ƚ��зֽ�
    cell_en = cell_src(1:s1,1:s2,:); %��ȡ3��ͨ����ÿ��ͨ����1��s1�����Լ�1��s2����
else % �����ʾlena.jpg��һ�ŻҶȻ�ڰ�ͼƬ������άͼ��ֻ��һ��ͨ��
    cell_src = mat2cell(src,d1,d2);
    cell_en = cell_src(1:s1,1:s2); 
end
cell_dst = cell_src;
cell_d = cell_en;

cell_d(key) = cell_en; 
%��cell_en���鰴��key����λ������
%����a=[10 11;12 13], b=a, c=[2 3 1 4]����b(c)=a��ʾa����c��������λ�ã���b=[11 12;10 13]
    cell_dst(1:s1,1:s2) = cell_d;
dst = cell2mat(cell_dst);%��cell����ת��Ϊ����

