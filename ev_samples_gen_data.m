clear;

config = ev_samples_config();

p = config.p;
n = config.n;
all_n = config.all_n;
all_dd = config.all_d;
all_rho = config.rho;
all_rep = config.repetitions;

K = config.K;

end_idx = cumsum(all_n);
start_idx = end_idx - all_n + 1;
gt_org = zeros(n, 1);

for kidx=1:K
    gt_org(start_idx(kidx):end_idx(kidx)) = kidx;
end

for k=8%1:length(all_rep)
    rep = all_rep(k);
    fprintf('Generate data for rep: %d\n', rep);
    
    for i=3:4%:length(all_rho)
        rho = all_rho(i);
        
        for j=1:size(all_dd, 2)
            
            all_d = all_dd(:, j);
            rank = config.d(j);
            
            [U, V, E] = gen_union_subspace(p, all_d, all_n, rho);
            
            Z = zeros(p, n);
            for kidx=1:K
                Z(:, start_idx(kidx):end_idx(kidx)) = U{kidx} * V{kidx}';
            end
            Z = Z + E;
            
            for zidx=1:size(Z,2)
                Z(:, i) = Z(:, i) / norm(Z(:, i));
            end
            
            perm = randperm(n);
            Z = Z(:, perm);
            gt = gt_org(perm);
            
            data_file = sprintf(config.data_file_format, rank, rho, rep);
            save(data_file, 'U', 'V', 'E', 'Z', 'gt', '-v7.3');
            fprintf('write data to %s\n', data_file);
        end
    end
end