function [W,V]=newpoly(X,Y,m)
% 这里有两种情况
% 一、从RGB映射到XYZ空间
% 二、从RGB直接映射到光谱反射比
% X:RGB值 3*n  3行n列
% Y 要看情况 如果是XYZ那就是3*n 3行n列
%W为转换矩阵，V扩展多项式。
X_2=size(X,2);
if (m==1)
    % 1st: [r g b]     3项 
    X_extend=ones(3,X_2);
    X_extend(1:3,:)=X;
    
    W=Y*(X_extend)'*pinv(X_extend*X_extend');
    
    V=X_extend;
    
elseif(m==2)
    % 2st: [r g b rg rb gb r^2 g^2 b^2]    9项
    X_extend=ones(9,X_2);
    X_extend(1:3,:)=X;
    X_extend(4,:)=X(1,:).^2;
    X_extend(5,:)=X(2,:).^2;
    X_extend(6,:)=X(3,:).^2;
    X_extend(7,:)=X(1,:).*X(2,:);
    X_extend(8,:)=X(2,:).*X(3,:);
    X_extend(9,:)=X(1,:).*X(3,:); 
     W=Y*(X_extend)'*pinv(X_extend*X_extend');
   
    V=X_extend;
    
elseif(m==3)
    % 3st:[  r g b rg rb gb r^2 g^2 b^2 r*g^2 r^2*g r*b^2 r^2*b gb^2 g^2b
    %       r^3  g^3 b^3 rgb];   19项
    X_extend=ones(19,X_2);
    X_extend(1:3,:)=X;
    X_extend(4,:)=X(1,:).^2;
    X_extend(5,:)=X(2,:).^2;
    X_extend(6,:)=X(3,:).^2;
    X_extend(7,:)=X(1,:).*X(2,:);
    X_extend(8,:)=X(2,:).*X(3,:);
    X_extend(9,:)=X(1,:).*X(3,:);
    X_extend(10,:)=X(1,:).^3;   %  r^3  g^3 b^3 rgb
    X_extend(11,:)=X(2,:).^3;
    X_extend(12,:)=X(3,:).^3;
    X_extend(13,:)=X(1,:).*X(2,:).^2;  % r*g^2
    X_extend(14,:)=X(2,:).*X(3,:).^2;
    X_extend(15,:)=X(1,:).*X(3,:).^2;
    X_extend(16,:)=X(2,:).*X(1,:).^2;
    X_extend(17,:)=X(3,:).*X(2,:).^2;
    X_extend(18,:)=X(3,:).*X(1,:).^2;
    X_extend(19,:)=X(1,:).*X(2,:).*X(3,:);
    
    
    W=Y*(X_extend)'*pinv(X_extend*X_extend');

    V=X_extend;
    
elseif(m==4)
    % 4st:[ 1 r g b rg rb gb r^2 g^2 b^2 r*g^2 r^2*g r*b^2 r^2*b gb^2 g^2b
    %       r^3  g^3 b^3 rgb
    %       rg^3  r^2g^2 r^3g rb^3 r^2b^2 r^3b g^3 b g^2* b^2 g^3*b
    %       r^2gb rg^2b rgb^2 r^4 g^4 b^4   ];   34项
    
    X_extend=ones(34,X_2);
    X_extend(1:3,:)=X;%rgb
    X_extend(4,:)=X(1,:).^2;%r2
    X_extend(5,:)=X(2,:).^2;%g2
    X_extend(6,:)=X(3,:).^2;%b2
    X_extend(7,:)=X(1,:).*X(2,:);%rg
    X_extend(8,:)=X(2,:).*X(3,:);%gb
    X_extend(9,:)=X(1,:).*X(3,:);%rb
    X_extend(10,:)=X(1,:).^3;   %  r^3  g^3 b^3 
    X_extend(11,:)=X(2,:).^3;%
    X_extend(12,:)=X(3,:).^3;
    X_extend(13,:)=X(1,:).*X(2,:).^2;  % r*g^2 gb2  rb2 gr2 bg2 br2 rgb
    X_extend(14,:)=X(2,:).*X(3,:).^2;
    X_extend(15,:)=X(1,:).*X(3,:).^2;
    X_extend(16,:)=X(2,:).*X(1,:).^2;
    X_extend(17,:)=X(3,:).*X(2,:).^2;
    X_extend(18,:)=X(3,:).*X(1,:).^2;
    X_extend(19,:)=X(1,:).*X(2,:).*X(3,:);
    
    X_extend(20,:)=X(1,:).^4; %  r^4 g^4 b^4 
    X_extend(21,:)=X(2,:).^4;
    X_extend(22,:)=X(3,:).^4;
    X_extend(23,:)=X(1,:).^3.*X(2,:);
    X_extend(24,:)=X(1,:).^3.*X(3,:);
    
    X_extend(25,:)=X(2,:).^3.*X(1,:);
    X_extend(26,:)=X(2,:).^3.*X(3,:);
    
    X_extend(27,:)=X(3,:).^3.*X(1,:);
    X_extend(28,:)=X(3,:).^3.*X(2,:);
    
    X_extend(29,:)=X(1,:).^2.*X(2,:).^2;
    X_extend(30,:)=X(2,:).^2.*X(3,:).^2;
    X_extend(31,:)=X(1,:).^2.*X(3,:).^2;
    X_extend(32,:)=X(1,:).^2.*X(2,:).*X(3,:);  %r^2gb rg^2b rgb^2
    X_extend(33,:)=X(2,:).^2.*X(1,:).*X(3,:);
    X_extend(34,:)=X(3,:).^2.*X(1,:).*X(2,:);
    
     W=Y*(X_extend)'*pinv(X_extend*X_extend');

     V=X_extend;
end
    
    
    
    
    