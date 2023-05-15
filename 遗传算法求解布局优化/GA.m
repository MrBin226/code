function  [chrx,MOC,PkG,LayoutG,best_X,best_Y] = GA(nchr,G,pc,pm)
%chrx:�洢ÿһ�������Ž�;MOC:�洢ÿһ�������Ž��Ŀ�꺯��ֵ,
%PkG�洢ÿһ�������Ž����Ӧ�ȣ�
%LayoutG,�洢ÿһ�����ų������з�ʽ
%best_X,�洢ÿһ�����ų��������У���������ĺ�����
%best_Y,�洢ÿһ�����ų��������У����������������
global H L DeviceSize T Cij Qij delta Tij Bij;
r = size(DeviceSize,1);%��������
%% ����������ĺ���
    % ����һ�γ�����������ܼ��,������[5,6,7,8],��dΪһ�����飬�洢��Ԫ��Ϊ5��6��6��7��7��8�ļ�࣬d_sΪ��d���
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
%    chr��Ⱦɫ�塣Dij�����صľ������
    function [Dij,nRow,Layout,x,y,D_max,b_ij] = GenerateDistanceMatrix(chr)
        m = chr;
        %��¼ÿ�����е��豸�ţ�������������������಻���ܳ���r(����������)�У�������һ��13*1��
        %cell�����¼��
        Layout = cell(r,1);
        k = 1;%Ⱦɫ������m�е�һ�������
        nRow = 1;%���е�����
        while k<r %whileѭ���������Զ����в����ж��豸�Ƿ�������
            for kk=k:r
                [~,d_s]=cal_delta(m(k:kk));
                if sum(DeviceSize(m(k:kk),1))+d_s > L
                    %�ж��Ƿ�û���
                    Layout{nRow} = m(k:kk-1);
                    k = kk;
                    break;
                end
            end
            nRow = nRow+1;
            %�ж��Ƿ����һ�У����������һ�еĳ���
            [~,d_s]=cal_delta(m(kk:end));
            if kk == r
                Layout{nRow} = m(kk);
            elseif sum(DeviceSize(m(kk:end),1))+d_s <= L
                Layout{nRow} = m(kk:end);
                break
            end
        end
        x = zeros(r,1);%�洢������x����
        y = zeros(r,1);%�洢������y����
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
                %ĳ��ֻ��һ���豸�������Ѿ��õ��豸�ĺ������ֱ꣬��ѭ����һ��nr
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

%% �������nchr����ʼ��Ⱥ
%�����Ƕ����������ÿ��������¾����е�������ԭ�������ţ�����CHR�൱�����������nchr
%��1��13���������
[~,CHR] = sort(rand(nchr,r),2);
%% Ŀ�꺯���Լ���Ӧ�Ⱥ������豸���У�������Ӧ�Ⱥ����ص㣬��Ŀ�꺯������Ӧ�Ⱥ���
%�Լ�����������һ������ʵ�֣������ظ�����
    function [C,Pk,Layout,x,y] = ObjfunEvalfun(chr)
        [Dij,~,Layout,x,y,D_max,b_ij] =  GenerateDistanceMatrix(chr);
        C1 = sum( sum(Cij.*Qij.*Dij) ) / sum( sum(Cij.*Qij.*D_max) );%Ŀ�꺯��ֵ
        C2 = sum( sum(b_ij.*Tij) ) / sum( sum(Tij) );
        C=C1-C2;
        [y_max,~]=max(y);
        h=max(DeviceSize((y==y_max),2)/2+y_max);
        Pk = 1/(1+ C+T*(h>H )+5);%��Ӧ�Ⱥ���ֵ
        if Pk < 0
            ttt=1;
        end
    end

%% ����G��,PkG�洢ÿһ�������Ž����Ӧ�ȣ�MOC,�洢ÿһ�������Ž��Ŀ�꺯��ֵ��
%chrx�洢ÿһ�������Ž⣬C������������ÿ��Ⱦɫ���Ŀ�꺯��ֵ��Pk������������ÿ��Ⱦɫ��
%����Ӧ�ȣ�LayoutG,�洢ÿһ�����ų������з�ʽ��Layoutnchr,ÿһ������Ⱥ����Ⱦɫ���
%�������з�ʽ��Layoutx���洢ÿһ���������峵���x���꣬Layouty���洢ÿһ���������峵���y����
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
    %% ����Ŀ�꺯��ֵ�Լ���Ӧ��
    for kn = 1:nchr
        [C(kn),Pk(kn),Layoutnchr{kn},Layoutx(kn,:),Layouty(kn,:)] = ObjfunEvalfun(CHR(kn,:));
    end
    [sortPk, ind] = sort(Pk);
 %�����Ĵ�������1�����������Ӧ��ֵ������һ�����š�����һ�������Ž������������Ž��.
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
    %% ѡ����������̶�ѡ��
    SelectP = Pk/sum(Pk);%ѡ�����
    %01���仮�֣������䳤�����ε��ڸ�����ѡ��ĸ��ʱ�����
    Interval01Divide=cumsum(SelectP);
    Test=rand(nchr,1);%����nchr��50����0��1�����
    %����������������ţ���ʾ���������ĸ��屻ѡ��
    TestResult=arrayfun(@(x) find(Interval01Divide>=x,1,'first'),Test);
    Frequency=accumarray(TestResult,1);%������ѡ�еĴ������������������帴�ƵĴ���
    Chr=cell(length(Frequency),1);
    for tt=1:length(Frequency)
        %����Frequencyÿ������������Ӧ����ĸ��ƴ���
        Chr{tt}=repmat(CHR(tt,:),Frequency(tt),1);
    end
    Chr=cell2mat(Chr);
    %% �ò����ǽ������
    RandMatch=randperm(nchr);%������
    for tt=1:nchr/2
        if rand>1-pc %���㽻�����,���潻��
            a1 = Chr(RandMatch(2*tt-1),:);%a1,a2���н����Ⱦɫ���豸���ж�
            a2 = Chr(RandMatch(2*tt),:);
            Points = sort(unidrnd(r,1,2));
             %����a1,a2
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
    %% �ò����Ǳ���������������13���������У�Ȼ��ֱ����������н��������Ӧ��ֵ��ѡȡ��������һ����б��죩
   for tt = 1:nchr
       if rand<pm %����������
           a=1:r;
           pos=zeros(r,2);
           for ra=1:r
            pos(ra,:)=a(randperm(numel(a),2)); %�������r��delta
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
%% ��Ⱥ����
   CHR = Chr;
   fprintf('��%d�ε�������ǰ��Ⱥ���Ÿ����Ŀ�꺯��ֵΪ%.4f\n',g,MOC(g));
end
end