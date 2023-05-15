function [V,munsell_xyz]=produce_data()

%%����Ŀ�ģ��������������ͬ�����ıȽϡ�
%%  10nm���  400-700nm   ѵ����ΪDSG�����Լ�ΪDSG
%  load  Xrite_SG_140.mat;
%  DSG=Xrite_SG_140;

% load surfs1995.mat;
% surfs=surfs1995;
% load Norm_camaera.mat;
 load munsell380_800_1;
 munsell=munsell(21:10:321,:);

% load vhrel.mat;
% vhrel=VHREL();

% load PI_data(1).mat;
% mcc=Mcc;

%%%�ӹ��׷���ȵ�XYZ������D65������
load lsources.dat;
lsources = lsources((400 - lsources(1,1) + 1):10:(700-lsources(1,1)+1),:);
light = lsources(:,5);
%%%%���������Sony

ccr = load('Sony_R');
ccg = load('Sony_G');
ccb = load('Sony_B');
ccr(:,2)=ccr(:,2).*light;
ccg(:,2)=ccg(:,2).*light;
ccb(:,2)=ccb(:,2).*light;
camera_s=[ccr(:,2) ccg(:,2) ccb(:,2)]';

%%  �������XRite_DSG_140.mat�������Ӧ�� 3�� 140��
 camera_munsell=camera_s*munsell;
 size(camera_munsell);
%%  �������XRite_DSG_140.mat�������Ӧ�� 3�� 140��
% camera_DSG=camera_s*DSG;
% size(camera_DSG);
%%%%����DSG��XYZֵ  ��������Ϊ400-700  10nm  ��ԴΪD65  CIE1964
wlength = [400 10 700];
lsource = 'D65';   
system = 1964;
%%
munsell_XYZ=colorconv_IPCV(munsell',[400 10 700],'D65',system);
Lab1=munsell_XYZ(:,10:12);
munsell_xyz=munsell_XYZ(:,4:6)';  %%%3 �� 140��



% ��DSG������չ
%��m=1ʱ��m�������������Ϊ4
m=1;
[W,V]=newrootpoly(camera_munsell,munsell_xyz,m);
% ��m=2ʱ������Ϊ9
%   m=2;
%   [W,V]=newrootpoly(camera_munsell,munsell_xyz,m);