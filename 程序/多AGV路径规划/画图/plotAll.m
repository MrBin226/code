function plotAll(m,n,obs,pick_table,agv,charg_pile)
for i = 1:m
    plot([0,n], [i, i], 'k');
    hold on
end    
for j = 1:n
     plot([j, j], [0, m], 'k');
end
axis equal
xlim([0, n]);
ylim([0, m]);   
% 绘制货架
for i = 1:size(obs,1)
    temp = obs(i,:);
    fill([temp(1), temp(1)+temp(3), temp(1)+temp(3), temp(1)],...
        [temp(2), temp(2) , temp(2)+temp(4), temp(2)+temp(4)], [0.5 0.5 0.5]);
end
% 绘制拣选台
for i = 1:size(pick_table,1)
    temp = pick_table(i,:);
    fill([temp(1), temp(1)+temp(3), temp(1)+temp(3), temp(1)],...
        [temp(2), temp(2) , temp(2)+temp(4), temp(2)+temp(4)], [240,128,128]/255);
end
% 绘制AGV停放区
for i = 1:size(agv,1)
    temp = agv(i,:);
    fill([temp(1), temp(1)+temp(3), temp(1)+temp(3), temp(1)],...
        [temp(2), temp(2) , temp(2)+temp(4), temp(2)+temp(4)], [100,149,237]/255);
end
% 绘制充电桩
for i = 1:size(charg_pile,1)
    temp = charg_pile(i,:);
    fill([temp(1), temp(1)+temp(3), temp(1)+temp(3), temp(1)],...
        [temp(2), temp(2) , temp(2)+temp(4), temp(2)+temp(4)], [255,20,147]/255);
end

% 绘制充电桩
for i = 1:size(charg_pile,1)
    temp = charg_pile(i,:);
    fill([temp(1), temp(1)+temp(3), temp(1)+temp(3), temp(1)],...
        [temp(2), temp(2) , temp(2)+temp(4), temp(2)+temp(4)], [255,20,147]/255);
end

end

