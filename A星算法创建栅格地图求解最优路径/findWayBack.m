%findWayBack������������·�����ݣ���������������������ֹ��goalposind�;���fieldpointers�����������P
function p = findWayBack(goalposind,fieldpointers)

    n = length(fieldpointers);  % ��ȡ�����ĳ���Ҳ����n
    posind = goalposind;
    [py,px] = ind2sub([n,n],posind); % ������ֵposindת��Ϊ����ֵ [py,px]
    p = [py px];
    
    %����whileѭ�����л��ݣ������ǻ��ݵ���ʼ���ʱ��ֹͣ��Ҳ�����ھ���fieldpointers���ҵ�Sʱֹͣ
    while ~strcmp(fieldpointers{posind},'S')
      switch fieldpointers{posind}
          
        case 'L' % ��L�� ��ʾ��ǰ�ĵ�������ߵĵ���չ������
          px = px - 1;
        case 'R' % ��R�� ��ʾ��ǰ�ĵ������ұߵĵ���չ������
          px = px + 1;
        case 'U' % ��U�� ��ʾ��ǰ�ĵ���������ĵ���չ������
          py = py - 1;
        case 'D' % ��D�� ��ʾ��ǰ�ĵ������±ߵĵ���չ������
          py = py + 1;
      end
      p = [p; py px];
      posind = sub2ind([n n],py,px);% ������ֵת��Ϊ����ֵ
    end
end
