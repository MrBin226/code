%
%      @���ߣ�����
%      @΢�Ź��ںţ��Ż��㷨������
%��ʼ����Ⱥ
function result =  init(np,cusnum,dist,demand,carnum,maxload)
    result=[];
    for i=1:np
        while 1
            result(i,:)=create(cusnum,dist,carnum);
            if test(decode(result(i,:)),demand,maxload)
                break;
            end
        end
    end
end