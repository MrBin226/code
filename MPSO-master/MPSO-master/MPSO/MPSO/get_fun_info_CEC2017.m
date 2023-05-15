function [Fun_Name,dim,L,U,opt_f,err] = get_fun_info_CEC2017(fun)
% Get the dimension, lower-, upper-bound and the optimal value for the function 'fun'

% Get the global optimal value of fun
dim=30;
%opt_f=0;
err=1e-8;   % Admissible error
Fun_Name='';
switch(fun) % fun from 1 to 30 are CEC207 functions
   %% Unimodal Functions
    case {1}
        Fun_Name='Shifted and Rotated Bent Cigar Function';
        LB = -100; UB = 100;
        opt_f = 100;
    case {2}  % F2 has been excluded because it shows unstable behavior especially for higher dimensions
        Fun_Name='Shifted and Rotated Sum of Different Power Function';
        LB = -100; UB = 100;
        opt_f = 200;
    case {3}
        Fun_Name='Shifted and Rotated Zakharov Function';
        LB = -100; UB = 100;
        opt_f = 300;
    %% Simple Multimodal Functions
    case {4}
        Fun_Name='Shifted and Rotated Rosenbrock¡¯s Function';
        LB = -100; UB = 100;
        opt_f = 400;
    case {5}
        Fun_Name='Shifted and Rotated Rastrigin¡¯s Function';
        LB = -100; UB = 100;
        opt_f = 500; 
    case {6}
        Fun_Name='Shifted and Rotated Expanded Scaffer¡¯s F6 Function';
        LB = -100; UB = 100;
        opt_f = 600;
    case {7}
        Fun_Name='Shifted and Rotated Lunacek Bi-Rastrigin Function';
        LB = -100; UB = 100;
        opt_f = 700;
    case {8}
        Fun_Name='Shifted and Rotated Non-Continuous Rastrigin¡¯s Function';
        LB = -100; UB = 100;
        opt_f = 800;
    case {9}
        Fun_Name='Shifted and Rotated Levy Function';
        LB = -100; UB = 100;
        opt_f = 900;
    case {10}
        Fun_Name='Shifted and Rotated Schwefel¡¯s Function';
        LB = -100; UB = 100;
        opt_f = 1000;
    %% Hybrid Functions
    case {11}
        Fun_Name='Hybrid Function 1 (N=3)';
        LB = -100; UB = 100;
        opt_f = 1100;
    case {12}
        Fun_Name='Hybrid Function 2 (N=3)';
        LB = -100; UB = 100;
        opt_f = 1200;
    case {13}
        Fun_Name='Hybrid Function 3 (N=3)';
        LB = -100; UB = 100;
        opt_f = 1300;
    case {14}
        Fun_Name='Hybrid Function 4 (N=4)';
        LB = -100; UB = 100;
        opt_f = 1400;
    case {15}
        Fun_Name='Hybrid Function 5 (N=4)';
        LB = -100; UB = 100;
        opt_f = 1500;
    case {16}
        Fun_Name='Hybrid Function 6 (N=4)';
        LB = -100; UB = 100;
        opt_f = 1600;
    case {17}
        Fun_Name='Hybrid Function 6 (N=5)';
        LB = -100; UB = 100;
        opt_f = 1700;
    case {18}
        Fun_Name='Hybrid Function 6 (N=5)';
        LB = -100; UB = 100;
        opt_f = 1800;
    case {19}
        Fun_Name='Hybrid Function 6 (N=5)';
        LB = -100; UB = 100;
        opt_f = 1900;
    case {20}
        Fun_Name='Hybrid Function 6 (N=6)';
        LB = -100; UB = 100;
        opt_f = 2000;
    %% Composition Functions
    case {21}
        Fun_Name='Composition Function 1 (N=3)';
        LB = -100; UB = 100;
        opt_f = 2100;
    case {22}
        Fun_Name='Composition Function 2 (N=3)';
        LB = -100; UB = 100;
        opt_f = 2200;
    case {23}
        Fun_Name='Composition Function 3 (N=4)';
        LB = -100; UB = 100;
        opt_f = 2300;
    case {24}
        Fun_Name='Composition Function 4 (N=4)';
        LB = -100; UB = 100;
        opt_f = 2400;
    case {25}
        Fun_Name='Composition Function 5 (N=5)';
        LB = -100; UB = 100;
        opt_f = 2500;
    case {26}
        Fun_Name='Composition Function 6 (N=5)';
        LB = -100; UB = 100;
        opt_f = 2600;
    case {27}
        Fun_Name='Composition Function 7 (N=6)';
        LB = -100; UB = 100;
        opt_f = 2700;
    case {28}
        Fun_Name='Composition Function 8 (N=6)';
        LB = -100; UB = 100;
        opt_f = 2800;
   case {29}
        Fun_Name='Composition Function 9 (N=3)';
        LB = -100; UB = 100;
        opt_f = 2900;
    case {30}
        Fun_Name='Composition Function 10 (N=3)';
        LB = -100; UB = 100;
        opt_f = 3000;
end

% If LB and UB are not vectors make them vectors
    sl = size(LB);

    if (sl(1)*sl(2) == 1) % LB and UB are scalers
        L = LB*ones(1,dim);
        U = UB*ones(1,dim);
    else
        L = LB;
        U = UB;
    end
end