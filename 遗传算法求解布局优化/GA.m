function  [chrx,MOC,PkG,LayoutG,best_X,best_Y] = GA(nchr,G,pc,pm)
%chrx:存储每一代的最优解;MOC:存储每一代的最优解的目标函数值,
%PkG存储每一代的最优解的适应度，
%LayoutG,存储每一代最优车间排列方式
%best_X,存储每一代最优车间排列中，各个车间的横坐标
%best_Y,存储每一代最优车间排列中，各个车间的纵坐标
global H L DeviceSize T Cij Qij delta Tij Bij;
r = size(DeviceSize,1);%车间数量
%% 计算距离矩阵的函数
    % 计算一段车间序列里的总间距,即例如[5,6,7,8],则d为一个数组，存储的元素为5和6，6和7，7和8的间距，d_s为对d求和
    function [d,d_s]=cal_delta(seq)
        if length(seq) == 1
            d=[];
            d_s=0;
        else
            d=zeros(1,length(seq));
            for i=1:length(seq)-1
                d(i)=delta(seq(i),seq(i+1));
            end
            d_s=sum(d);
        end
    end
%    chr：染色体。Dij：返回的距离矩阵
    function [Dij,nRow,Layout,x,y,D_max,b_ij] = GenerateDistanceMatrix(chr)
        m = chr;
        %记录每行排列的设备号，由于行数不定，但最多不可能超过r(即车间数量)行，所以用一个13*1的
        %cell数组记录。
        Layout = cell(r,1);
        k = 1;%染色体序列m中第一个车间号
        nRow = 1;%排列的行数
        while k<r %while循环：按照自动换行策略判断设备是否排列完
            for kk=k:r
                [~,d_s]=cal_delta(m(k:kk));
                if sum(DeviceSize(m(k:kk),1))+d_s > L
                    %判断是否该换行
                    Layout{nRow} = m(k:kk-1);
                    k = kk;
                    break;
                end
            end
            nRow = nRow+1;
            %判断是否到最后一行，并布置最后一行的车间
            [~,d_s]=cal_delta(m(kk:end));
            if kk == r
                Layout{nRow} = m(kk);
            elseif sum(DeviceSize(m(kk:end),1))+d_s <= L
                Layout{nRow} = m(kk:end);
                break
            end
        end
        x = zeros(r,1);%存储各车间x坐标
        y = zeros(r,1);%存储各车间y坐标
        for nr = 1:nRow
            x( Layout{nr}(1) ) = DeviceSize(Layout{nr}(1),1) / 2;
            if nr == 1
                y(Layout{nr}) = DeviceSize(Layout{nr},2) / 2;
            else
                pre_y=y(Layout{nr-1})+DeviceSize(Layout{nr-1},2) / 2;
                now_y=delta(Layout{nr},Layout{nr-1})+pre_y';
                y(Layout{nr}) = DeviceSize(Layout{nr},2) / 2 + max(now_y,[],2);
            end
            if length(Layout{nr}) == 1 
                %某行只有一个设备，上面已经得到设备的横纵坐标，直接循环下一个nr
                continue;
            end
            for nc = 2:length(Layout{nr})
                x(Layout{nr}(nc)) = x(Layout{nr}(nc-1)) +...
                    mean( DeviceSize(Layout{nr}([nc-1,nc]),1) ) + ...
                    delta( Layout{nr}(nc-1),Layout{nr}(nc) );
            end
        end
        Dij = zeros(r);
        D_max=zeros(r);
        b_ij=zeros(r);
        for ii=1:r
            for jj=1:r
                D_max(ii,jj)=H+L;
                Dij(ii,jj) = abs(x(ii) - x(jj))+abs( y(ii)-y(jj) );
                tep=find(Dij(ii,jj)>=Bij(:,1));
                b_ij(ii,jj)=Bij(tep(end),3);
            end
        end
    end

%% 随机生成nchr个初始种群
%由于是对随机数矩阵每行排序后新矩阵中的数字在原矩阵的序号，所以CHR相当于随机生成了nchr
%个1到13的随机排序
[~,CHR] = sort(rand(nchr,r),2);
%% 目标函数以及适应度函数，设备排列，根据适应度函数特点，将目标函数和适应度函数
%以及车间排列用一个函数实现，减少重复计算
    function [C,Pk,Layout,x,y] = ObjfunEvalfun(chr)
        [Dij,~,Layout,x,y,D_max,b_ij] =  GenerateDistanceMatrix(chr);
        C1 = sum( sum(Cij.*Qij.*Dij) ) / sum( sum(Cij.*Qij.*D_max) );%目标函数值
        C2 = sum( sum(b_ij.*Tij) ) / sum( sum(Tij) );
        C=C1-C2;
        [y_max,~]=max(y);
        h=max(DeviceSize((y==y_max),2)/2+y_max);
        Pk = 1/(1+ C+T*(h>H )+5);%适应度函数值
        if Pk < 0
            ttt=1;
        end
    end

%% 进化G次,PkG存储每一代的最优解的适应度，MOC,存储每一代的最优解的目标函数值，
%chrx存储每一代的最优解，C，进化过程中每代染色体的目标函数值，Pk，进化过程中每代染色体
%的适应度，LayoutG,存储每一代最优车间排列方式，Layoutnchr,每一代中种群各个染色体的
%车间排列方式，Layoutx，存储每一代各个个体车间的x坐标，Layouty，存储每一代各个个体车间的y坐标
PkG = zeros(G,1);
MOC = zeros(G,1);
best_X = zeros(G,r);
best_Y = zeros(G,r);
chrx=zeros(G,r);
LayoutG = cell(G,1);
Layoutnchr = cell(nchr,1);
Layoutx = zeros(nchr,r);
Layouty = zeros(nchr,r);
C = zeros(nchr,1);
Pk = zeros(nchr,1);
for g = 1:G
    %% 计算目标函数值以及适应度
    for kn = 1:nchr
        [C(kn),Pk(kn),Layoutnchr{kn},Layoutx(kn,:),Layouty(kn,:)] = ObjfunEvalfun(CHR(kn,:));
    end
    [sortPk, ind] = sort(Pk);
 %进化的代数大于1，但是最大适应度值不如上一代的优。用上一代的最优结果替代本代最优结果.
    if g>1 &&  sortPk(end) < PkG(g-1)
       PkG(g) = PkG(g-1);
       chrx(g,:) = chrx(g-1,:);
       MOC(g) = MOC(g-1);
       LayoutG{g} = LayoutG{g-1};
       best_X(g,:) = best_X(g-1,:);
       best_Y(g,:) = best_Y(g-1,:);
    else
        PkG(g) = sortPk(end);
        chrx(g,:) = CHR(ind(end),:); 
        MOC(g) = C(ind(end),:);
        LayoutG{g} = Layoutnchr{ind(end)};
        best_X(g,:) = Layoutx(ind(end),:);
        best_Y(g,:) = Layouty(ind(end),:);
    end
    %% 选择操作，轮盘赌选择
    SelectP = Pk/sum(Pk);%选择概率
    %01区间划分（各区间长度依次等于各个体选择的概率比例）
    Interval01Divide=cumsum(SelectP);
    Test=rand(nchr,1);%生成nchr（50）个0，1随机数
    %随机数落入的区间序号，表示该区间代表的个体被选中
    TestResult=arrayfun(@(x) find(Interval01Divide>=x,1,'first'),Test);
    Frequency=accumarray(TestResult,1);%各个体选中的次数，进而决定各个体复制的次数
    Chr=cell(length(Frequency),1);
    for tt=1:length(Frequency)
        %根据Frequency每个分量决定相应个体的复制次数
        Chr{tt}=repmat(CHR(tt,:),Frequency(tt),1);
    end
    Chr=cell2mat(Chr);
    %% 该部分是交叉操作
    RandMatch=randperm(nchr);%随机配对
    for tt=1:nchr/2
        if rand>1-pc %满足交叉概率,下面交叉
            a1 = Chr(RandMatch(2*tt-1),:);%a1,a2进行交叉的染色体设备序列段
            a2 = Chr(RandMatch(2*tt),:);
            Points = sort(unidrnd(r,1,2));
             %交叉a1,a2
            for uu = 0:range(Points)
                a1(a1==a2(Points(1)+uu)) = a1(Points(1)+uu);
                temp = a1(Points(1)+uu);
                a1(Points(1)+uu) = a2(Points(1)+uu);
                a2(a2==temp) = a2(Points(1)+uu);
                a2(Points(1)+uu) = temp;
            end
            Chr(RandMatch(2*tt-1),:) =a1;
            Chr(RandMatch(2*tt),:) = a2;
        end
    end
    %% 该部分是变异操作（随机产生13组两两序列，然后分别计算各个序列交换后的适应度值，选取其中最大的一组进行变异）
   for tt = 1:nchr
       if rand<pm %满足变异概率
           a=1:r;
           pos=zeros(r,2);
           for ra=1:r
            pos(ra,:)=a(randperm(numel(a),2)); %随机生成r个delta
           end
           PkTemp = zeros(1,r);
           for tr = 1:r
               chr_temp=Chr(tt,:);
               ttemp=chr_temp(pos(tr,1));
               chr_temp(pos(tr,1)) = chr_temp(pos(tr,2));
               chr_temp(pos(tr,2)) = ttemp;
               [~,PkTemp(tr)] = ObjfunEvalfun(chr_temp);
           end
           [maxPktemp,indmax] = max(PkTemp);
           ttemp=Chr(tt,pos(indmax,1));
           Chr(tt,pos(indmax,1)) = Chr(tt,pos(indmax,2));
           Chr(tt,pos(indmax,2)) = ttemp;
       end
   end
%% 种群更新
   CHR = Chr;
   fprintf('第%d次迭代，当前种群最优个体的目标函数值为%.4f\n',g,MOC(g));
end
end