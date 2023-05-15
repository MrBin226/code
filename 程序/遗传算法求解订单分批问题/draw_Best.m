
function draw_Best(VC,vertexs,origin_coordinate)
customer=vertexs(1:end,:);
tt=customer(:,1);
customer(:,1)=customer(:,2);
customer(:,2)=tt;
customer(:,1)=customer(:,1)*2;
temp=customer;
NV=size(VC,1);                                        
h=figure(2);
hold on;box on
title('最优拣选方案路线图')
axis([0 7 0 6]);
hold on;
C=linspecer(NV);
for i=1:NV
    part_seq=VC{i};           
    len=length(part_seq);   
    for j=0:len
        if j==0
            c1=customer(part_seq(1),1:2);
            if customer(part_seq(1),3)>5.5
                c1(1)=c1(1)+0.18*(customer(part_seq(1),3)-5);
            else
                c1(1)=c1(1)-0.18*(6-customer(part_seq(1),3));
            end
            plot([origin_coordinate(1,1),c1(1)],[origin_coordinate(1,2),c1(2)],'-','color',C(i,:),'linewidth',1);
        %当j=len时，车辆从该路径上的最后一个客户出发到达配送中心
        elseif j==len
            c_len=customer(part_seq(len),1:2);
            if customer(part_seq(len),3)>5.5
                c_len(1)=c_len(1)+0.18*(customer(part_seq(len),3)-5);
            else
                c_len(1)=c_len(1)-0.18*(6-customer(part_seq(len),3));
            end
            plot([c_len(1),origin_coordinate(1,1)],[c_len(2),origin_coordinate(1,2)],'-','color',C(i,:),'linewidth',1);
        %否则，车辆从路径上的前一个客户到达该路径上紧邻的下一个客户
        else
            c_pre=customer(part_seq(j),1:2);
            c_lastone=customer(part_seq(j+1),1:2);
            if customer(part_seq(j),3)>5.5
                c_pre(1)=c_pre(1)+0.18*(customer(part_seq(j),3)-5);
            else
                c_pre(1)=c_pre(1)-0.18*(6-customer(part_seq(j),3));
            end
            if customer(part_seq(j+1),3)>5.5
                c_lastone(1)=c_lastone(1)+0.18*(customer(part_seq(j+1),3)-5);
            else
                c_lastone(1)=c_lastone(1)-0.18*(6-customer(part_seq(j+1),3));
            end
            plot([c_pre(1),c_lastone(1)],[c_pre(2),c_lastone(2)],'-','color',C(i,:),'linewidth',1);
        end
    end
end
for i=1:size(customer,1)
    if customer(i,3)>5.5
        customer(i,1)=customer(i,1)+0.18*(customer(i,3)-5);
    else
        customer(i,1)=customer(i,1)-0.18*(6-customer(i,3));
    end
    plot(customer(i,1),customer(i,2),'ro','linewidth',1);
    if i==1
        a=unique(temp(1:i,:),'rows');
    else
        if sum(ismember(temp(1:i-1,:),temp(i,:),'rows'))>0
            a=temp(1:i-1,:);
            len=sum(ismember(temp(1:i-1,:),temp(i,:),'rows'));
        else
            a=temp(1:i,:);
            len=0;
        end
    end
    if size(a,1)==i
        text(customer(i,1),customer(i,2)+0.1,num2str(i));
    else
        text(customer(i,1),customer(i,2)+0.2*len+0.2,num2str(i));
    end
end
hold on;
plot(origin_coordinate(1,1),origin_coordinate(1,2),'s','linewidth',2,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
end

