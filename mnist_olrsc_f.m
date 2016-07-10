clear;

config = mnist_config();

method = 'olrsc-f';

K = config.K;
epochs = config.epoch;

%% add path
addpath('OLRSC/');

%% load data
data_file = config.data_file;
load(data_file);

result_file = sprintf(config.result_file_format, method, method);

%% compute EV for LRR

fprintf('OLRSC-F: K = %d\n', K);

[p, n] = size(Z);

lambda1 = 1;
lambda2 = 1/sqrt(p);
lambda3_base = 1/sqrt(p);

d = 5 * K;

M = zeros(p, d);
A = zeros(d, d);
B = zeros(p, d);

D = randn(p, d);

V = zeros(n, d);

tic;
for ep=1:epochs
    for t=1:n
        
        if mod(t, 1000) == 0
            fprintf('OLRSC: access sample %d\n', t);
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
        
        V(t, :) = v';
    end
    
    M = zeros(p, d);
end

T = toc;

% Note that for convenience we use batch k-means to obtain the clustering accuracy and running time.
% One can easily implement the online k-means

tic;
groups = kmeans(V, K, 'maxiter', 1000, 'replicates', 20, 'EmptyAction', 'singleton'); % the setting here follows the one in the SSC toolkit
T_kmeans = toc;

Acc_kmeans = 1- Misclassification(groups, gt);

fprintf('epoch %d, Acc = %g\n', ep, Acc_kmeans);

save(result_file, 'T', 'Acc_kmeans', 'T_kmeans');
fprintf('save to %s\n', result_file);