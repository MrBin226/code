%
%      @���ߣ�����
%      @΢�Ź��ںţ��Ż��㷨������
%���Խ��Ƿ���������Լ��������flag=1������flag=0
function flag = test(route,demand,maxload)
    flag=1;
    [~,n]=size(route);
    for i =1:n
    sum=0;
        for j =1:length(route{i})
            sum=sum+demand(route{i}(j)+1);
        end
        if sum>maxload
            flag=0;
            break;
        end
    end
end