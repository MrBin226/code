function pop=m_Incoding(binPop,r_min,r_max,q_min,q_max,pop_length)
%% ����
popNum = 2;%Ⱦɫ������Ĳ�������,����2��������r��Q
pop=zeros(popNum,size(binPop,2));
for n=1:size(binPop,2)
    Matrix = binPop{1,n};
    l=1;
    for num=1:popNum
        pop(num,n) = gray2bin(Matrix(l:pop_length(num)+l-1));%bin2dec���������ַ���ת��Ϊ10������
        l=pop_length(num)+1;
    end
end
%��Ϊ����r�ķ�Χ��[1,5]����Ⱦɫ�峤����3����һ�������ƴ����Ա�ʾ[0,7]������������Ҫ��[0,7]ӳ�䵽[1,5]
%һ��[m,n]ӳ�䵽[a,b]�����ת����ʽ�ǣ�x=(b-a)*(y-n)/(m-n)+a������yΪ[m,n]����,xΪ[a,b]����
%��Ϊr��Qֻ��ȡ������������Ҫ��ӳ����ֵ����ȡ��,round()����
pop(1,:) = round(((r_max-r_min)/(2^pop_length(1)-1))*pop(1,:)+r_min);
pop(2,:) = round(((q_max-q_min)/(2^pop_length(2)-1))*pop(2,:)+q_min);
