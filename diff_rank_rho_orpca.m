clear;

config = diff_rank_rho_config();

method = 'orpca';

all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;

p = config.p;
n = config.n;

% default setting in the OR-PCA paper
lambda1 = 1;
lambda2 = 1/sqrt(p);

%% add path
addpath('OR-PCA');

%% compute EV for LRR

for k=1:length(all_rep)
    rep = all_rep(k);
    
    for j=1:length(all_d)
        d = all_d(j);
        
        for i=1:length(all_rho)
            rho = all_rho(i);
            
            fprintf('OR-PCA: rep = %d, d = %d, rho = %.2f\n', rep, d, rho);
            
            result_file = sprintf(config.result_file_format, method, method, d, rho, rep);            
            
            data_file = sprintf(config.data_file_format, d, rho, rep);
            load(data_file);
            
            U_all = cell2mat(U);
            UUt = U_all * U_all';
            traceUUt = trace(UUt);
            
            L = randn(p, d);
            
            A = zeros(d, d);
            B = zeros(p, d);
            
            EV = zeros(1, n);
            
            for t=1:n
                if mod(t, 1000) == 0
                    fprintf('OR-PCA: access sample %d, EV = %g\n', t, EV(t-1));
                end
                
                z = Z(:, t);
                
                [r, e] = solve_proj2(z, L, lambda1, lambda2);
                
                A = A + r * r';
                B = B + (z-e) * r';
                
                L = update_col_orpca(L, A, B, lambda1);
                
                EV(t) = js_compute_EV(L, UUt, traceUUt);
            end
            
            save(result_file, 'EV');
            fprintf('save to %s\n', result_file);
            
        end
    end
end