%%%%
%### make sure you run "ev_samples_dictlearn.m" in advance ###
%%%

clear;

config = ev_samples_config();

method = 'olrsc2';
method_dict = 'dictlearn';

all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;

p = config.p;
n = config.n;

K = config.K;

lambda1 = 1;
lambda2 = 1/sqrt(p);
lambda3_base = 1/sqrt(p);

%% add path
addpath('OLRSC/');

%% compute EV for OLRSC2

for k=1:length(all_rep)
    rep = all_rep(k);
    
    for j=1:length(all_d)
        d = all_d(j);
        
        for rhoidx=1:length(all_rho)
            rho = all_rho(rhoidx);
            
            fprintf('OLRSC2: rep = %d, d = %d, rho = %.2f\n', rep, d, rho);
            
            result_file = sprintf(config.result_file_format, method, method, d, rho, rep);
            
            data_file = sprintf(config.data_file_format, d, rho, rep);
            load(data_file);
            
            dict_file = sprintf(config.result_file_format, method_dict, method_dict, d, rho, rep);
            if ~exist(dict_file, 'file')
                error('Please run the script ev_samples_dictlearn.m in advance');
            end
            
            load(dict_file, 'Y');
            
            U_all = cell2mat(U);
            UUt = U_all * U_all';
            traceUUt = trace(UUt);
            
            D = randn(p, d);
            
            M = zeros(p, d);
            A = zeros(d, d);
            B = zeros(p, d);
            
            EV = zeros(1, n);
            T = 0;
            
            for t=1:n
                if mod(t, 1000) == 0
                    fprintf('OLRSC2 access sample %d, EV = %g\n', t, EV(t-1));
                end
                
                tic;
                
                z = Z(:, t);
                y = Y(:, t);
                lambda3 = sqrt(t) * lambda3_base;
                
                [v, e] = OLRR_solve_ve(z, D, lambda1, lambda2);
                
                normy = norm(y);
                u = (D - M)' * y / (normy * normy + 1/lambda3);
                
                M = M + y * u';
                A = A + v * v';
                B = B + (z-e) * v';
                
                D = OLRR_solve_D(D, M, A, B, lambda1, lambda3);
                
                T = T + toc;
                
                EV(t) = js_compute_EV(D, UUt, traceUUt);
                
            end
            
            save(result_file, 'EV', 'T');
            fprintf('save to %s\n', result_file);
            
        end
    end
end