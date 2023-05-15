%% �����������ͷ���·��ͼ
%���룺VC              ���ͷ���
%���룺vertexs         ������ľ��Ⱥ�γ��
function draw_Best(VC,vertexs)
customer=vertexs(2:end,:);                                      %�ŵ꾭�Ⱥ�γ��
NV=size(VC,1);                                                  %����ʹ����Ŀ
figure
hold on
box on
title('�������ͷ���·��ͼ')
axis([116.1,116.9,39.6,40.3])
C=linspecer(NV);
for i=1:NV
    part_seq=VC{i};            %ÿ�������������ŵ�
    len=length(part_seq);                           %ÿ�������������ŵ�����
    for j=0:len
        %��j=0ʱ���������������ĳ��������·���ϵĵ�һ���ŵ�
        if j==0
            fprintf('%s','����·��',num2str(i),'��');
            fprintf('%d->',0);
            c1=customer(part_seq(1),:);
            plot([vertexs(1,1),c1(1)],[vertexs(1,2),c1(2)],'-','color',C(i,:),'linewidth',1);
        %��j=lenʱ�������Ӹ�·���ϵ����һ���ŵ����������������
        elseif j==len
            fprintf('%d->',part_seq(j));
            fprintf('%d',0);
            fprintf('\n');
            c_len=customer(part_seq(len),:);
            plot([c_len(1),vertexs(1,1)],[c_len(2),vertexs(1,2)],'-','color',C(i,:),'linewidth',1);
        %���򣬳�����·���ϵ�ǰһ���ŵ굽���·���Ͻ��ڵ���һ���ŵ�
        else
            fprintf('%d->',part_seq(j));
            c_pre=customer(part_seq(j),:);
            c_lastone=customer(part_seq(j+1),:);
            plot([c_pre(1),c_lastone(1)],[c_pre(2),c_lastone(2)],'-','color',C(i,:),'linewidth',1);
        end
    end
end
plot(customer(:,1),customer(:,2),'ro','linewidth',1);
vers = vertexs;
vers(7,:)=[];
vers(22,:)=[];
for k=1:size(vers,1)
    if k==1
        text(vers(k,1)+0.01,vers(k,2)+0.007,'21');
    else
        text(vers(k,1)-0.007,vers(k,2)+0.007,num2str(k-1));
    end
end
plot(vertexs(1,1),vertexs(1,2),'s','linewidth',2,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
hold off
end

