function draw_route(route,m_node)
%������ʻ·��
%   route��·��
%   m_node����Ŧ�ڵ�

%% �ڵ����������
x_y=[119.007829 39.25095; 
    118.937544 39.348358; 
    117.955427 40.220231; 
    118.72767 39.507748; 
    118.710799 39.617655; 
    118.791744 40.107334; 
    118.709172 39.711187; 
    118.463644 39.152211; 
    118.449948 38.990009]; 
x_y_text={'���Ƹ�','��ׯ','�񻯱�','����','��ׯ��','Ǩ����','���ɽ','�����鱱','��������'};

%% ��ʼ����
for i=1:length(route)
    rt=route{i};
    fprintf('%d(���)->',rt(1));
    if length(rt)>2
        for j=2:length(rt)-1
            fprintf('%d(��ת)->',rt(j));
        end
    end
    fprintf('%d(�յ�)\n',rt(end));
end

figure(1)
hold on
xlabel('������');
ylabel('������');

for i=1:length(route)
    rt=route{i};
    for j=1:length(rt)-1
        drawArrow(x_y(rt(j),:),x_y(rt(j+1),:),'black','black',0.5);
    end
end
if isempty(m_node)
    t1=scatter(x_y(:,1),x_y(:,2),40,'filled','red');
    legend(t1,'����Ŧ�ڵ�');
else
    m_x_y=x_y(m_node,:);
    n_x_y=x_y(setdiff(1:size(x_y,1),m_node),:);
    t1=scatter(n_x_y(:,1),n_x_y(:,2),40,'filled','red');
    t2=scatter(m_x_y(:,1),m_x_y(:,2),50,'d','filled','red');
    legend([t1,t2],'����Ŧ�ڵ�','��Ŧ�ڵ�');
end
for i=1:length(x_y_text)
    text(x_y(i,1)+0.05,x_y(i,2)+0.05,x_y_text{i});
end
hold off
end

