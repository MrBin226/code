function [W,V]=newrootpoly(X,Y,m)
% 这里有两种情况
% 一、从RGB映射到XYZ空间
% 二、从RGB直接映射到光谱反射比
% X:RGB值 3*n  3行n列
% Y 要看情况 如果是XYZ那就是3*n 3行n列
%W为转换矩阵，V扩展多项式。
%X为相机响应，m
X_2=size(X,2);
if (m==1)
    % 1st: [ r g b]    3项
    X_rootextend=ones(3,X_2);
    X_rootextend(1: 3,:)=X;
    W=Y*(X_rootextend)'*pinv(X_rootextend*X_rootextend');
    V=X_rootextend;
    
elseif(m==2)
    % 2: [r,g,b, √rg, √gb, √rb ]   6项
    X_rootextend=ones(6,X_2);
    X_rootextend(1:3,:)=X;
    X_rootextend(4,:)=(X(1,:).*X(2,:)).^(1/2);
    X_rootextend(5,:)=(X(2,:).*X(3,:)).^(1/2);
    X_rootextend(6,:)=(X(1,:).*X(3,:)).^(1/2);

    W=Y*(X_rootextend)'*pinv(X_rootextend*X_rootextend');
    V=X_rootextend;
    
elseif(m==3)
    % 3根号:[   r  g  b   √rg     √gb   √rb   
%     ?√r*g^2    ?√gb^2     ?√r*b^2     
% ?√g*r^2    ?√bg^2      ?√br^2     ?√rgb]   13项
    X_rootextend=ones(13,X_2);
    X_rootextend(1:3,:)=X;
    X_rootextend(4,:)=(X(1,:).*X(2,:)).^(1/2);
    X_rootextend(5,:)=(X(2,:).*X(3,:)).^(1/2);
    X_rootextend(6,:)=(X(1,:).*X(3,:)).^(1/2);
    
    X_rootextend(7,:)=(X(1,:).*X(2,:).^2).^(1/3);
    X_rootextend(8,:)=(X(2,:).*X(3,:).^2).^(1/3);
    X_rootextend(9,:)=(X(1,:).*X(3,:).^2).^(1/3);
    
    X_rootextend(10,:)=(X(2,:).*X(1,:).^2).^(1/3); 
    X_rootextend(11,:)=(X(3,:).*X(2,:).^2).^(1/3);
    X_rootextend(12,:)=(X(3,:).*X(1,:).^2).^(1/3);  
    X_rootextend(13,:)=(X(1,:).*X(2,:).*X(3,:)).^(1/3);
    W=Y*(X_rootextend)'*pinv(X_rootextend*X_rootextend');
    V=X_rootextend;
    
elseif(m==4)
    % [   r  g  b   √rg     √gb    √rb   ?√r*g^2    ?√gb^2     ?√r*b^2   
%   ?√g*r^2    ?√bg^2      ?√br^2  ?√b^2g   ?√rgb     
%  4√r^3*g    4√r^3*b     4√g^3*r     4√g^3*b    4√b^3*r      4√b^3*g
%  4√r^2gb      4√g^2rb    4√b^2rg]   22项
    
    X_rootextend=ones(22,X_2);
    X_rootextend(1:3,:)=X;
    X_rootextend(4,:)=(X(1,:).*X(2,:)).^(1/2);
    X_rootextend(5,:)=(X(2,:).*X(3,:)).^(1/2);
    X_rootextend(6,:)=(X(1,:).*X(3,:)).^(1/2);
    
    X_rootextend(7,:)=(X(1,:).*X(2,:).^2).^(1/3);%rg2
    X_rootextend(8,:)=(X(2,:).*X(3,:).^2).^(1/3);%gb2
    X_rootextend(9,:)=(X(1,:).*X(3,:).^2).^(1/3);%rb2
    
    X_rootextend(10,:)=(X(2,:).*X(1,:).^2).^(1/3); %gr2
    X_rootextend(11,:)=(X(3,:).*X(2,:).^2).^(1/3);%bg2
    X_rootextend(12,:)=(X(3,:).*X(1,:).^2).^(1/3); %br2
    X_rootextend(13,:)=(X(1,:).*X(2,:).*X(3,:)).^(1/3);%rgb
    
    X_rootextend(14,:)=(X(1,:).^3.*X(2,:)).^(1/4);  
    X_rootextend(15,:)=(X(1,:).^3.*X(3,:)).^(1/4);
    
    X_rootextend(16,:)=(X(2,:).^3.*X(1,:)).^(1/4);   
    X_rootextend(17,:)=(X(2,:).^3.*X(3,:)).^(1/4);
    
    X_rootextend(18,:)=(X(3,:).^3.*X(1,:)).^(1/4);
    X_rootextend(19,:)=(X(3,:).^3.*X(2,:)).^(1/4);
    
    X_rootextend(20,:)=(X(1,:).^2.*X(2,:).*X(3,:)).^(1/4);  
    X_rootextend(21,:)=(X(2,:).^2.*X(1,:).*X(3,:)).^(1/4);
    X_rootextend(22,:)=(X(3,:).^2.*X(1,:).*X(2,:)).^(1/4);
    
    W=Y*(X_rootextend)'*pinv(X_rootextend*X_rootextend');
    V=X_rootextend;
     
end