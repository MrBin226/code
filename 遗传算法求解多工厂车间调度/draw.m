function draw(number,scheme,m_k,time,p_ij,f)
figure()
axis([0 time+2,0,sum(m_k)+1])
la=cell(1,sum(m_k)+1);
la{1}=' ';
flag=2;
idx=cell(length(m_k),1);
for i=1:length(m_k)
    for j=1:m_k(i)
        la{flag}=['工序',num2str(i),'机器',num2str(j)];
        idx{i}=[idx{i},flag-1];
        flag=flag+1;
    end
end
set(gca,'yticklabel',la)
for i=1:length(scheme)
    t=scheme{i};
    for j=1:size(t,1)
         rectangle('Position',[t(j,2),idx{j}(t(j,1))-0.25,p_ij(number(i),j),0.5],'edgecolor','r','facecolor','c');
         text(t(j,2)+p_ij(number(i),j)/2,idx{j}(t(j,1)),num2str(number(i)));
    end
end
title(['工厂',num2str(f),'的甘特图'])
xlabel('时间')

end

