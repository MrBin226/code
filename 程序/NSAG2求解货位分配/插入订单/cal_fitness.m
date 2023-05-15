function [T] = cal_fitness(position)
%CAL_FITNESS 计算适应度函数
global out_order_pos in_order_pos warehouse;
% 解码
[~,seq]=sort(position);
T=0;
x_end=((warehouse.v_c)^2/(warehouse.a_c)*warehouse.l);
y_end=((warehouse.v_s)^2/(warehouse.a_s)*warehouse.h);
for i=1:length(seq)
    if out_order_pos(seq(i),3) == in_order_pos(i,3)
        % 若出入库在同层
        if out_order_pos(i,3)<=y_end
            t_h=2*sqrt(out_order_pos(i,3)*warehouse.h/warehouse.a_s);
        else
            t_h=out_order_pos(i,3)*warehouse.h/warehouse.v_s+...
                      warehouse.v_s/warehouse.a_s;
        end
        if out_order_pos(i,1)<=x_end
            t_l=2*sqrt(out_order_pos(i,1)*warehouse.l/warehouse.a_c);
        else
            t_l=out_order_pos(i,1)*warehouse.l/warehouse.v_c+...
                      warehouse.v_c/warehouse.a_c;
        end
        t_w=out_order_pos(i,1)*warehouse.l*4/warehouse.v_c;
        T=T+2*(t_h+warehouse.t_sf+warehouse.t_sr)+t_l+3*warehouse.t_cf+4*warehouse.t_cr+2*(t_w+2*warehouse.t_zf+warehouse.t_zr);
    else
        % 若出入库在不同层
        if out_order_pos(i,3)<=y_end
            t_h_i=2*sqrt(out_order_pos(i,3)*warehouse.h/warehouse.a_s);
        else
            t_h_i=out_order_pos(i,3)*warehouse.h/warehouse.v_s+...
                      warehouse.v_s/warehouse.a_s;
        end
        if out_order_pos(seq(i),3)<=y_end
            t_h_j=2*sqrt(out_order_pos(seq(i),3)*warehouse.h/warehouse.a_s);
        else
            t_h_j=out_order_pos(seq(i),3)*warehouse.h/warehouse.v_s+...
                      warehouse.v_s/warehouse.a_s;
        end
        if abs(out_order_pos(i,3)-out_order_pos(seq(i),3))<=y_end
            t_h_j_i=2*sqrt(abs(out_order_pos(i,3)-out_order_pos(seq(i),3))*warehouse.h/warehouse.a_s);
        else
            t_h_j_i=abs(out_order_pos(i,3)-out_order_pos(seq(i),3))*warehouse.h/warehouse.v_s+...
                      warehouse.v_s/warehouse.a_s;
        end
        if out_order_pos(seq(i),1)<=x_end
            t_l_j=2*sqrt(out_order_pos(seq(i),1)*warehouse.l/warehouse.a_c);
        else
            t_l_j=out_order_pos(seq(i),1)*warehouse.l/warehouse.v_c+...
                      warehouse.v_c/warehouse.a_c;
        end
        if out_order_pos(i,1)<=x_end
            t_l_i=2*sqrt(out_order_pos(i,1)*warehouse.l/warehouse.a_c);
        else
            t_l_i=out_order_pos(i,1)*warehouse.l/warehouse.v_c+...
                      warehouse.v_c/warehouse.a_c;
        end
        t_w_j=out_order_pos(seq(i),1)*warehouse.l*4/warehouse.v_c;
        t_w_i=out_order_pos(i,1)*warehouse.l*4/warehouse.v_c;
        t1=t_h_i+t_h_j_i+3*warehouse.t_sf+2*warehouse.t_sr;
        t2=2*(t_l_j+2*warehouse.t_cf+2*warehouse.t_cr+t_w_j+2*warehouse.t_zf+warehouse.t_zr);
        t3=2*(t_l_i+warehouse.t_cf+warehouse.t_cr+t_w_i+warehouse.t_zf)+warehouse.t_zr+t_h_i+warehouse.t_sf;
        T=T+max(t3,max(t1,t2)+t_h_j);
    end
end

end

