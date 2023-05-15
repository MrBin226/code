function [cost] = cal_cost(pop,c,f,l,a1,a2,first_end,P,c_kt,c_k)
%¼ÆËã³É±¾
%   
cost=zeros(size(pop,1),1);
for i=1:size(pop,1)
    route = decode(pop(i,:),c,f,l,a1,a2,first_end,P,c_kt);
    m_node=P(pop(i,:)==1);
    z2=sum(c_k(m_node));
    z1=0;
    z3=0;
    for j=1:length(route)
        rt = route{j};
%         if sum(ismember(m_node,rt(1)))==1 || sum(ismember(m_node,rt(end)))==1
%             flag = including(m_node,rt(1),rt(end));
%             if length(rt)==2
%                 switch(flag)
%                     case 0
%                         z1=z1+a2*f(rt(1),rt(end))*l(rt(1),rt(2))*c(rt(1),rt(2));
%                     case 1
%                         z1=z1+f(rt(1),rt(2))*l(rt(1),rt(2))*c(rt(1),rt(2));
%                     case 2
%                         z1=z1+a1*f(rt(1),rt(2))*l(rt(1),rt(2))*c(rt(1),rt(2));
%                 end
%             else
%                 if flag==1
%                     z1=z1+f(rt(1),rt(2))*l(rt(1),rt(2))*c(rt(1),rt(2));
%                 else
%                     z1=z1+a1*f(rt(1),rt(2))*l(rt(1),rt(2))*c(rt(1),rt(2));
%                 end
%                 mm_node=rt(2:end-1);
%                 if length(mm_node)>1
%                     for k=1:length(mm_node)-1
%                         z1=z1+a1*f(rt(1),rt(end))*l(mm_node(k),mm_node(k+1))*c(mm_node(k),mm_node(k+1));
%                         z3=z3+c_kt(mm_node(k))*f(rt(1),rt(end));
%                     end
%                 end
%                 if flag==0
%                     z1=z1+a2*f(rt(1),rt(end))*l(rt(end-1),rt(end))*c(rt(end-1),rt(end));
%                 else
%                     z1=z1+a1*f(rt(1),rt(end))*l(rt(end-1),rt(end))*c(rt(end-1),rt(end));
%                 end
%                 z3=z3+c_kt(rt(end-1))*f(rt(1),rt(end));
%             end
%         else
            if length(rt)==2
                z1=z1+f(rt(1),rt(2))*l(rt(1),rt(2))*c(rt(1),rt(2));
            else
                z1=z1+f(rt(1),rt(end))*l(rt(1),rt(2))*c(rt(1),rt(2));
                mm_node=rt(2:end-1);
                if length(mm_node)>1
                    for k=1:length(mm_node)-1
                        z1=z1+a1*f(rt(1),rt(end))*l(mm_node(k),mm_node(k+1))*c(mm_node(k),mm_node(k+1));
                        z3=z3+c_kt(mm_node(k))*f(rt(1),rt(end));
                    end
                end
                z1=z1+a2*f(rt(1),rt(end))*l(rt(end-1),rt(end))*c(rt(end-1),rt(end));
                z3=z3+c_kt(rt(end-1))*f(rt(1),rt(end));
            end
        end
%     end
    cost(i)=z1+z2+z3;
end
end

