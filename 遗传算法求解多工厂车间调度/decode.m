function [scheme,time]=decode(chromsome,c,m_k,p)
scheme=cell(length(chromsome),1);
for k=1:length(chromsome)
    scheme{k}=zeros(c,2);
end
c_end=zeros(length(chromsome),1);
trans=chromsome;
for i=1:c
    num=m_k(i);
    end_time=ones(m_k(i),1)*min(c_end);
    for j=1:length(trans)
        if j==1
            scheme{find(chromsome==trans(j))}(i,:)=[1,c_end(j)];
            c_end(j)=p(trans(j),i)+c_end(j);
            end_time(1)=p(trans(j),i)+end_time(1);
            num=num-1;
        else
            if i~=1
                tx=end_time(end_time<=c_end(j));
                if isempty(tx)
                    tx=end_time;
                end
            else
                tx=end_time;
            end
            [t,~]=min(tx);
            idx=find(end_time==t);
            scheme{find(chromsome==trans(j))}(i,:)=[idx(1),max([t,c_end(j)])];
            end_time(idx(1))=p(trans(j),i)+max([t,c_end(j)]);
            c_end(j)=p(trans(j),i)+max([t,c_end(j)]);
        end
    end
    [c_end,index]=sort(c_end);
    trans=trans(index);
end
time=max(c_end);
end

