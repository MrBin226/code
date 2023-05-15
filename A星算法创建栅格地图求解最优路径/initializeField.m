%% 
%�����������þ���������ɻ������ϰ����ʼ�㣬��ֹ���
function [field, startposind, goalposind, costchart, fieldpointers] = initializeField(n,wall,startposind,goalposind)
    field = ones(n,n) + 10*rand(n,n);%����һ��n*n�ĵ�λ����+0��10��Χ�ڵ�һ�������
    field(wall) = Inf;%���ϰ������ڵ�λ����ΪINF
    field(startposind) = 0; field(goalposind) = 0;  %�Ѿ�������ʼ�����ֹ�㴦��ֵ��Ϊ0
    
    costchart = NaN*ones(n,n);%����һ��nxn�ľ���costchart��ÿ��Ԫ�ض���ΪNaN�����Ǿ����ʼNaN��Ч����
    costchart(startposind) = 0;%�ھ���costchart�н���ʼ��λ�ô���ֵ��Ϊ0
    
    % ����Ԫ������
    fieldpointers = cell(n,n);%����Ԫ������n*n
    fieldpointers{startposind} = 'S'; fieldpointers{goalposind} = 'G'; %��Ԫ���������ʼ���λ�ô���Ϊ 'S'����ֹ�㴦��Ϊ'G'
    fieldpointers(field==inf)={0};
    
   
end
% end of this function