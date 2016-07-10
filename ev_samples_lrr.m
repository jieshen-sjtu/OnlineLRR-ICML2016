clear;

config = ev_samples_config();

method = 'lrr';

all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;

p = config.p;
n = config.n;

K = config.K;

lambda = 1/sqrt(max(p, n));

%% add path
addpath('LRR/');

%% compute EV for LRR

for k=1:length(all_rep)
    rep = all_rep(k);
    
    for j=1:length(all_d)
        d = all_d(j);
        
        for i=1:length(all_rho)
            rho = all_rho(i);
            
            fprintf('LRR: rep = %d, d = %d, rho = %.2f\n', rep, d, rho);
            
            result_file = sprintf(config.result_file_format, method, method, d, rho, rep);
            
            data_file = sprintf(config.data_file_format, d, rho, rep);
            load(data_file);
            
            U_all = cell2mat(U);
            UUt = U_all * U_all';
            traceUUt = trace(UUt);
            
            tic;
            [X, ~] = solve_lrr(Z, Z, lambda, 1, 1);
            T = toc;
            
            [D, ~, ~] = svds(Z*X, d);
            
            ev = js_compute_EV(D, UUt, traceUUt);
            
            EV = ev * ones(1, n);
            
            save(result_file, 'EV', 'T');
            fprintf('EV = %g, save to %s\n', ev, result_file);
            
        end
    end
end