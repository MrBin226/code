function [V,munsell_xyz]=produce_data()

%%程序目的：相机特征化，不同阶数的比较。
%%  10nm间隔  400-700nm   训练集为DSG，测试集为DSG
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

%%%从光谱反射比到XYZ，采用D65照明。
load lsources.dat;
lsources = lsources((400 - lsources(1,1) + 1):10:(700-lsources(1,1)+1),:);
light = lsources(:,5);
%%%%相机灵敏度Sony

ccr = load('Sony_R');
ccg = load('Sony_G');
ccb = load('Sony_B');
ccr(:,2)=ccr(:,2).*light;
ccg(:,2)=ccg(:,2).*light;
ccb(:,2)=ccb(:,2).*light;
camera_s=[ccr(:,2) ccg(:,2) ccb(:,2)]';

%%  下面计算XRite_DSG_140.mat的相机响应。 3行 140列
 camera_munsell=camera_s*munsell;
 size(camera_munsell);
%%  下面计算XRite_DSG_140.mat的相机响应。 3行 140列
% camera_DSG=camera_s*DSG;
% size(camera_DSG);
%%%%计算DSG的XYZ值  光谱区间为400-700  10nm  光源为D65  CIE1964
wlength = [400 10 700];
lsource = 'D65';   
system = 1964;
%%
munsell_XYZ=colorconv_IPCV(munsell',[400 10 700],'D65',system);
Lab1=munsell_XYZ(:,10:12);
munsell_xyz=munsell_XYZ(:,4:6)';  %%%3 行 140列



% 对DSG进行扩展
%当m=1时，m代表阶数，项数为4
m=1;
[W,V]=newrootpoly(camera_munsell,munsell_xyz,m);
% 当m=2时，项数为9
%   m=2;
%   [W,V]=newrootpoly(camera_munsell,munsell_xyz,m);