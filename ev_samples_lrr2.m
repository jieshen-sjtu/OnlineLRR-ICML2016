%%%%
%### make sure you run "ev_samples_dictlearn.m" in advance ###
%%%%

clear;

config = ev_samples_config();

method = 'lrr2';
method_dict = 'dictlearn';

all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;

p = config.p;
n = config.n;

K = config.K;

lambda = 1/sqrt(max(p, n));

%% add path
addpath('LRR/');

%% compute EV for LRR2

for k=1:length(all_rep)
    rep = all_rep(k);
    
    for j=1:length(all_d)
        d = all_d(j);
        
        for i=1:length(all_rho)
            rho = all_rho(i);
            
            fprintf('LRR2: rep = %d, d = %d, rho = %.2f\n', rep, d, rho);
            
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
            
            tic;
            [X, ~] = solve_lrr(Z, Y, lambda, 1, 1);
            T = toc;
            
            [D, ~, ~] = svds(Y*X, d);
            
            ev = js_compute_EV(D, UUt, traceUUt);
            
            EV = ev * ones(1, n);
            
            save(result_file, 'EV', 'T');
            fprintf('EV = %g, save to %s\n', ev, result_file);
            
        end
    end
end