function [ pop ] = initPoP(N,gen_len,R1,R2_min,R2_max,R3,R4,R5,R6,C1,C2,a)
%   初始化种群
%   
pop = zeros(N,gen_len);
for i=1:N
    pop(i,:) = [unifrnd(R1*(1-a),R1*(1+a)),unifrnd(R2_min,R2_max),unifrnd(R3*(1-a),R3*(1+a)),unifrnd(R4*(1-a),R4*(1+a)),...
                unifrnd(R5*(1-a),R5*(1+a)),unifrnd(R6*(1-a),R6*(1+a)),unifrnd(C1*(1-a),C1*(1+a)),unifrnd(C2*(1-a),C2*(1+a))];
end
end

