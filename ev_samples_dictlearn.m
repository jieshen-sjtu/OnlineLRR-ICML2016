clear;

config = ev_samples_config();

method = 'dictlearn';

all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;

p = config.p;
n = config.n;

K = config.K;

lambda = 1/sqrt(max(p, n));

%% add path
addpath('LRR/');
addpath('PROPACK');
addpath('inexact_alm_rpca');

%% compute dictionary for LRR2
for k=1:length(all_rep)
    rep = all_rep(k);
    
    for j=1:length(all_d)
        d = all_d(j);
        
        for i=1:length(all_rho)
            rho = all_rho(i);
            
            fprintf('DictLearn: rep = %d, d = %d, rho = %.2f\n', rep, d, rho);
            
            result_file = sprintf(config.result_file_format, method, method, d, rho, rep);
            
            
            data_file = sprintf(config.data_file_format, d, rho, rep);
            load(data_file, 'Z');
            
            tic;
            Y = dictlearn(Z, lambda);
            T = toc;
            
            save(result_file, 'Y', 'T');
            fprintf('save to %s\n', result_file);
            
        end
    end
end