%% ����vehicles_customer�����final_vehicles_customer����vehicles_customer�пյ������Ƴ�
%���룺vehicles_customer        ÿ�����������Ĺ˿�
%�����final_vehicles_customer  ɾ�������飬������vehicles_customer
function [fvc,vehicles_used]=deal_vehicles_customer(VC)
vecnum=size(VC,1);               %������
fvc={};                     %������vehicles_customer
count=1;                                        %������
for i=1:vecnum
    par_seq=VC{i};               %ÿ�����������Ĺ˿�
    %����������������˿͵�������Ϊ0�������������Ĺ˿�������ӵ�final_vehicles_customer��
    if ~isempty(par_seq)                        
        fvc{count}=par_seq;
        count=count+1;
    end
end
%% Ϊ�����׿������������ɵ�1�ж��е�final_vehicles_customerת���ˣ���ɶ���1�е���
fvc=fvc';       
vehicles_used=size(fvc,1);              %��ʹ�õĳ�����
end