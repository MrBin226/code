function [max_temp]=cal_max_temp(sol,x1,y1,l_d,x2,y2,lamda_c,lamda_g,a_c,a_lamda,S,row,column,T)
t=ones(row+2,column+2);
t(1,:)=T;
t(:,1)=T;
t(row+2,:)=T;
t(:,column+2)=T;
e=1e-5;
k=1;
layout=reshape(sol,column,row)';
lamda_h1=(lamda_c*lamda_g)/(2*lamda_g*x1+lamda_c*x2);
lamda_h2=(lamda_c*lamda_g)/(2*lamda_g*y1+lamda_c*y2);
c1=2*lamda_h1*y1*l_d/x1+2*lamda_h2*x1*l_d/y1+(a_c+a_lamda)*x1*y1;
c2=1/c1;
c3=(a_c*x1*y1*T+a_lamda*x1*y1*T)/c1;
c4=(lamda_h1*y1*l_d/x1)/c1;
c5=(lamda_h2*x1*l_d/y1)/c1;

while 1
    tt=t;
    for i=2:2+row-1
        for j=2:2+column-1
            t(i,j)=c3+c2*S(layout(i-1,j-1))+c4*t(i-1,j)+c4*t(i+1,j)+c5*t(i,j-1)+c5*t(i,j+1);
        end
    end
    k=k+1;
    ttt=abs(t(2,2)-tt(2,2));
    if (ttt<e)
        break
    end
end
max_temp=max(max(t(2:2+row-1,2:2+column-1)));
end
