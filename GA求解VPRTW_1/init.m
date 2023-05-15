
function [init_vc] = init(cusnum,customers_time,demands,cap,len,dist)
a = customers_time(:,1);
j=ceil(rand*cusnum);                    %�����й˿������ѡ��һ���˿�
k=1;                                    %ʹ�ó�����Ŀ����ʼ����Ϊ1
init_vc=cell(k,1);
% �����������У�����ÿ���˿ͣ���ִ�����²���
if j==1
    seq=1:cusnum;
elseif j==cusnum
    seq=[cusnum,1:j-1];
else
    seq1=1:j-1;
    seq2=j:cusnum;
    seq=[seq2,seq1];
end
% ��ʼ����
route=[];       %�洢ÿ��·���ϵĹ˿�
load=0;         %��ʼ·�����ڲֿ��װ����Ϊ0
dis=dist(1,seq(1)+1);          %��������ʻ����
i=1;
while i<=cusnum
    %���û�г�������Լ����������ʱ�䴰��С�����˿���ӵ���ǰ·��
    if load == 0
        d = dis;
    else
        d = dis+dist(seq(i-1)+1,seq(i)+1);
    end
    if load+demands(seq(i))<=cap &&  d<= len      
        load=load+demands(seq(i));          %��ʼ�ڲֿ��װ��������
        if load ~= demands(seq(i))
            dis=dis+dist(seq(i-1)+1,seq(i)+1);
        end
        %�����ǰ·��Ϊ�գ�ֱ�ӽ��˿���ӵ�·����
        if isempty(route)
            route=[seq(i)];
        %�����ǰ·��ֻ��һ���˿ͣ�������¹˿�ʱ����Ҫ������ʱ�䴰��С�������
        elseif length(route)==1
            if a(seq(i))<=a(route(1))
                route=[seq(i),route];   
            else
                route=[route,seq(i)];
            end
        else
            lr=length(route);       %��ǰ·������,����lr-1�������Ĺ˿�
            flag=0;                 %����Ƿ��������1�Թ˿ͣ�����seq(i)��������֮��
            %������lr-1�������Ĺ˿͵��м����λ��
            for m=1:lr-1
                if (a(seq(i))>=a(route(m)))&&(a(seq(i))<=a(route(m+1)))
                    route=[route(1:m),seq(i),route(m+1:end)];
                    flag=1;
                    break
                end
            end
            %�������������1�Թ˿ͣ�����seq(i)��������֮�䣬Ҳ����flag=0������Ҫ��seq(i)�嵽routeĩβ
            if flag==0
                route=[route,seq(i)];
            end
        end
        %������������һ���˿ͣ������init_vc������������
        if i==cusnum
            init_vc{k,1}=route;
            break
        end
        i=i+1;
    else   %һ�����������ػ���Լ��������Ҫ����һ����
        %�ȴ�����һ�����������Ĺ˿�
        init_vc{k,1}=route;
        %Ȼ��route��գ�load����,k��1
        route=[];
        load=0;
        dis=dist(1,seq(i)+1);
        k=k+1;
    end
end
end

