function [new_pos] = adjust(pos,pick_num,cargo,cargo_num,q,cargo_coord,pick_coord)
cargo_of_pick=floor(pos);
new_pos=zeros(size(pos));
if length(unique(cargo_of_pick))==pick_num
    new_pos=pos;
    return
end
insert_pick=setdiff(1:pick_num,unique(cargo_of_pick));
for i=1:pick_num
    t2=cargo(cargo_of_pick==i);
    [~,idx]=sort(pos(cargo_of_pick==i));
    pick_to_cargo{i}=t2(idx);
    pick_to_cargo_num(i)=sum(cargo_num(pick_to_cargo{i}));
end
remove=[];
while ~isempty(find(pick_to_cargo_num>q))
    [~,idx]=max(pick_to_cargo_num);
    dis=[];
    for k=1:length(pick_to_cargo{idx})
        [~,temp]=ismember(setdiff(pick_to_cargo{idx},pick_to_cargo{idx}(k),'stable'),cargo_coord(:,1));
        dis(k)=cal_distance([idx,setdiff(pick_to_cargo{idx},pick_to_cargo{idx}(k),'stable'),idx],[pick_coord(idx,:);cargo_coord(temp,2:3);pick_coord(idx,:)]);
    end
    [~,tt]=min(dis);
    remove=[remove pick_to_cargo{idx}(tt)];
    pick_to_cargo{idx}=setdiff(pick_to_cargo{idx},pick_to_cargo{idx}(tt),'stable');
    pick_to_cargo_num(idx)=sum(cargo_num(pick_to_cargo{idx}));
end
for i=1:pick_num
    new_pos(pick_to_cargo{i})=pos(pick_to_cargo{i});
end

for i=1:length(insert_pick)
    dis=[];
    for j=1:length(remove)
        dis(j)=sum(abs(pick_coord(insert_pick(i),:)-cargo_coord(cargo_coord(:,1)==remove(j),2:3)));
    end
    [~,tt]=min(dis);
    pick_to_cargo{insert_pick(i)}=remove(tt);
    remove(tt)=[];
    pick_to_cargo_num(insert_pick(i))=sum(cargo_num(pick_to_cargo{insert_pick(i)}));
end
while ~isempty(remove)
    dis=[];
    for i=1:length(insert_pick)
        dis(i)=sum(abs(cargo_coord(cargo_coord(:,1)==pick_to_cargo{insert_pick(i)}(end),2:3)-...
            cargo_coord(cargo_coord(:,1)==remove(1),2:3)))-sum(abs(cargo_coord(cargo_coord(:,1)==pick_to_cargo{insert_pick(i)}(end),2:3)-...
            pick_coord(insert_pick(i),:)))+sum(abs(cargo_coord(cargo_coord(:,1)==remove(1),2:3)-...
            pick_coord(insert_pick(i),:)))+100*max(pick_to_cargo_num(insert_pick(i))+cargo_num(remove(1))-q,0);
    end
    [~,tt]=min(dis);
    pick_to_cargo{insert_pick(tt)}=[pick_to_cargo{insert_pick(tt)} remove(1)];
    pick_to_cargo_num(insert_pick(tt))=sum(cargo_num(pick_to_cargo{insert_pick(tt)}));
    remove(1)=[];
end
for i=1:length(insert_pick)
    new_pos(pick_to_cargo{insert_pick(i)})=sort(rand(1,length(pick_to_cargo{insert_pick(i)})).*(0.99)+insert_pick(i));
end
end

