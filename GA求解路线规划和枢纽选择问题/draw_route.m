function draw_route(route,m_node)
%绘制行驶路线
%   route：路线
%   m_node：枢纽节点

%% 节点的坐标数据
x_y=[119.007829 39.25095; 
    118.937544 39.348358; 
    117.955427 40.220231; 
    118.72767 39.507748; 
    118.710799 39.617655; 
    118.791744 40.107334; 
    118.709172 39.711187; 
    118.463644 39.152211; 
    118.449948 38.990009]; 
x_y_text={'京唐港','聂庄','遵化北','滦南','柏庄村','迁安北','菱角山','曹妃甸北','曹妃甸西'};

%% 开始绘制
for i=1:length(route)
    rt=route{i};
    fprintf('%d(起点)->',rt(1));
    if length(rt)>2
        for j=2:length(rt)-1
            fprintf('%d(中转)->',rt(j));
        end
    end
    fprintf('%d(终点)\n',rt(end));
end

figure(1)
hold on
xlabel('横坐标');
ylabel('纵坐标');

for i=1:length(route)
    rt=route{i};
    for j=1:length(rt)-1
        drawArrow(x_y(rt(j),:),x_y(rt(j+1),:),'black','black',0.5);
    end
end
if isempty(m_node)
    t1=scatter(x_y(:,1),x_y(:,2),40,'filled','red');
    legend(t1,'非枢纽节点');
else
    m_x_y=x_y(m_node,:);
    n_x_y=x_y(setdiff(1:size(x_y,1),m_node),:);
    t1=scatter(n_x_y(:,1),n_x_y(:,2),40,'filled','red');
    t2=scatter(m_x_y(:,1),m_x_y(:,2),50,'d','filled','red');
    legend([t1,t2],'非枢纽节点','枢纽节点');
end
for i=1:length(x_y_text)
    text(x_y(i,1)+0.05,x_y(i,2)+0.05,x_y_text{i});
end
hold off
end

