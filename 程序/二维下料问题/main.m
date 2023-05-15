clc;
clear;
close all;

%% ��ز�������
data = textread('data.txt');
m=data(1,1);
W=data(2,1);
H=data(2,2);
w=data(3:2+m,1)';
h=data(3:2+m,2)';

%% �㷨������ʼ
sol_new=init(m,W,H,w,h);%ÿ�β������½�
sol_current=sol_new;%��ǰ��
sol_best=sol_new;%��õĽ�
E_new=cal_fit(sol_new,w,h,W,H);
E_current=E_new;
E_best=E_new;
T0=100;%��ʼ�¶�
Tf=1;%��ֹ�¶�
T=T0;%��ǰ�¶�
degrad=0.99;%��ȴϵ��
Markov_length=600;%����ɷ����ĳ���
min_fit=[];
while Tf<=T
    for i=1:Markov_length
        % �����µĽ⣨�������2��λ�ã�
        temp=[];
        for k=1:length(sol_new)
            temp=[temp sol_new{k}];
        end
        idx=sort(randi(m,1,3));
        temp=[temp(1:idx(1)),temp(idx(2)+1:idx(3)),temp(idx(1)+1:idx(2)),temp(idx(3)+1:end)];
        sol_new=trans(temp,w,h,W,H);
        %�����½��Ŀ�꺯��ֵ
        E_new=cal_fit(sol_new,w,h,W,H);
        %�˻����
        if E_new < E_current
            E_current=E_new;
            sol_current=sol_new;
            if E_new < E_best
                E_best=E_new;
                sol_best=sol_new;
            end
        else
            % ���½�Ŀ�꺯��ֵ���ڵ�ǰ�⣬����һ�����ʽ���
            if rand() < exp(-(E_new-E_current)/T)
                E_current=E_new;
                sol_current=sol_new;
            else
                % �������½�
                sol_new=sol_current;
            end
        end
    end
    T=degrad*T;
    min_fit=[min_fit E_best];
end

disp('������Ӧ��ֵΪ��');
disp(E_best);
fprintf('ʹ��%d��ԭ����\n',length(sol_best));
for i=1:length(sol_best)
    fprintf('��%d���и�Ĳ�ƷΪ��',i);
    tt=sol_best{i};
    figure(i)
    hold on
    axis([0 H 0 W])
    hh=0;
    t=tt;
    temp=[];
    ttt=0;
    x=0;
    y=0;
    while ~isempty(t)
        r = 1;  
        if (t(r)<0)
            temp=[temp,w(-t(r))];
            hh=hh+h(-t(r));
        else
            temp=[temp,h(t(r))];
            hh=hh+w(t(r));
        end
        if hh>W
            ttt=ttt+max(temp(1:end-1));
            temp=[];
            if (t(r)<0)
                temp=[temp,w(-t(r))];
                hh=h(-t(r));
            else
                temp=[temp,h(t(r))];
                hh=w(t(r));
            end
            y=ttt;
            x=0;
        end
        if (t(r)<0)
            rectangle('Position',[x,y,h(-t(r)),w(-t(r))]);
            text(x+h(-t(r))/2,y+w(-t(r))/2,num2str(-t(r)));
        else
            rectangle('Position',[x,y,w(t(r)),h(t(r))]);
            text(x+w(t(r))/2,y+h(t(r))/2,num2str(t(r)));
        end
        x=hh;
        t(1)=[];
    end
    title(['��',num2str(i),'��ԭ���ϵ��и��'])
    hold off
    for j=1:length(tt)
        if tt(j)>0
            a='��ֱ';
        else
            a='����';
        end
        
        fprintf('%d(%s)\t',abs(tt(j)),a);
    end
    fprintf('\n');
end





function [seq]=init(m,W,H,w,h)
t=[1:m];
t=[t,-t];
t=t(randperm(2*m));
hh=0;
seq=cell(10,1);
temp=[];
num=1;
ttt=0;
while ~isempty(t)
    r = ceil(rand*length(t));  
    if (t(r)<0)
        temp=[temp,w(-t(r))];
        hh=hh+h(-t(r));
    else
        temp=[temp,h(t(r))];
        hh=hh+w(t(r));
    end
    if hh>W
        ttt=ttt+max(temp(1:end-1));
        temp=[];
        if (t(r)<0)
            temp=[temp,w(-t(r))];
            hh=h(-t(r));
        else
            temp=[temp,h(t(r))];
            hh=w(t(r));
        end
    end
    if ttt+temp(end)>H
        num=num+1;
        ttt=0;
        temp=[];
        hh=0;
        continue
    end
    seq{num}=[seq{num} t(r)];
    a=t(r);
    t(t==a)=[];
    t(t==-a)=[];
end
seq(cellfun(@isempty,seq))=[];
end

function fitness=cal_fit(sol,w,h,W,H)
fitness=0;
for i=1:length(sol)
    temp=sol{i};
    temp=abs(temp);
    fitness=fitness+(W*H)/sum(w(temp).*h(temp));
end
end

function seq=trans(temp,w,h,W,H)
hh=0;
t=temp;
seq=cell(10,1);
temp=[];
num=1;
ttt=0;
while ~isempty(t)
    r = 1;  
    if (t(r)<0)
        temp=[temp,w(-t(r))];
        hh=hh+h(-t(r));
    else
        temp=[temp,h(t(r))];
        hh=hh+w(t(r));
    end
    if hh>W
        ttt=ttt+max(temp(1:end-1));
        temp=[];
        if (t(r)<0)
            temp=[temp,w(-t(r))];
            hh=h(-t(r));
        else
            temp=[temp,h(t(r))];
            hh=w(t(r));
        end
    end
    if ttt+temp(end)>H
        num=num+1;
        ttt=0;
        temp=[];
        hh=0;
        continue
    end
    seq{num}=[seq{num} t(r)];
    t(1)=[];
end
seq(cellfun(@isempty,seq))=[];

end



