clear;

config = diff_rank_rho_config();

method = 'olrsc';

all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;
K = config.K;
epochs = config.epoch;

p = config.p;
n = config.n;

lambda1 = 1;
lambda2 = 1/sqrt(p);
lambda3_base = 1/sqrt(p);

%% add path
addpath('OLRSC/');

%% compute EV for OLRSC

for k=1:length(all_rep)
    rep = all_rep(k);
    
    for j=1:length(all_d)
        d = all_d(j);
        
        for rhoidx=1:length(all_rho)
            rho = all_rho(rhoidx);
            
            fprintf('OLRSC: rep = %d, d = %d, rho = %.2f\n', rep, d, rho);
            
            result_file = sprintf(config.result_file_format, method, method, d, rho, rep);
            
            data_file = sprintf(config.data_file_format, d, rho, rep);
            load(data_file);
            
            U_all = cell2mat(U);
            UUt = U_all * U_all';
            traceUUt = trace(UUt);
            
            D = randn(p, d);
            
            M = zeros(p, d);
            A = zeros(d, d);
            B = zeros(p, d);
            
            EV = zeros(1, n);
            
            for t=1:n
                if mod(t, 1000) == 0
                    fprintf('OLRSC access sample %d\n', t);
                end
                
                z = Z(:, t);
                lambda3 = sqrt(t) * lambda3_base;
                
                [v, e] = OLRR_solve_ve(z, D, lambda1, lambda2);
                
                normz = norm(z);
                u = (D - M)' * z / (normz * normz + 1/lambda3);
                
                M = M + z * u';
                A = A + v * v';
                B = B + (z-e) * v';
                
                D = OLRR_solve_D(D, M, A, B, lambda1, lambda3);
                
                EV(t) = js_compute_EV(D, UUt, traceUUt);
            end
            
            save(result_file, 'EV');
            fprintf('save to %s\n', result_file);
            
        end
    end
end