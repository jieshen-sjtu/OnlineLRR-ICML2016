clear;

config = mnist_config();

method = 'orpca';

K = config.K;
epochs = config.epoch;

%% add path
addpath('OR-PCA/');
addpath('SSC/');

%% load data
data_file = config.data_file;
load(data_file);

result_file = sprintf(config.result_file_format, method, method);

%% compute EV for LRR

fprintf('OR-PCA: K = %d ', K);

[p, n] = size(Z);

lambda1 = 1/sqrt(p);
lambda2 = 1/sqrt(p);


d = K * 5;


L = randn(p, d);
R = zeros(n, d);

A = zeros(d, d);
B = zeros(p, d);


tic;
for ep=1:epochs
    for t=1:n
        
        if mod(t, 1000) == 0
            fprintf('OR-PCA: access sample %d\n', t);
        end
        
        z = Z(:, t);
        
        [r, e] = solve_proj2(z, L, lambda1, lambda2);
        
        
        A = A + r * r';
        B = B + (z-e) * r';
        
        L = update_col_orpca(L, A, B, lambda1);
        
        R(t, :) = r';
    end
    
end

T = toc;

tic;

X = L * R';
[~, ~, VX] = svds(X, d);
Xsym = BuildAdjacency(VX * VX');
groups = SpectralClustering(Xsym, K);

Acc = 1 - Misclassification(groups, gt);

T_spec = toc;

fprintf('epoch %d, Acc = %g\n', ep, Acc);

save(result_file, 'Acc', 'T', 'T_spec');
fprintf('save to %s\n', result_file);