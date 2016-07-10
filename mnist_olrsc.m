clear;

config = mnist_config();

method = 'olrsc';

K = config.K;
epochs = config.epoch;

%% add path
addpath('OLRSC/');
addpath('SSC/');

%% load data
data_file = config.data_file;
load(data_file);

result_file = sprintf(config.result_file_format, method, method);

%% compute Acc for OLRSC

fprintf('OLRSC: K = %d\n', K);

[p, n] = size(Z);

lambda1 = 1;
lambda2 = 1/sqrt(p);
lambda3_base = 1/sqrt(p);

d = 5 * K;

M = zeros(p, d);
A = zeros(d, d);
B = zeros(p, d);
U = zeros(n, d);
V = zeros(n, d);

D = randn(p, d);

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
        
        U(t, :) = u';
        V(t, :) = v';
    end
    
    M = zeros(p, d);
end
T = toc;

tic;

X = U * V';
Xsym = BuildAdjacency(X);
groups = SpectralClustering(Xsym, K);
Acc = 1 - Misclassification(groups, gt);

T_spec = toc;

fprintf('epoch %d, Acc = %g\n', ep, Acc);
save(result_file, 'Acc', 'T', 'T_spec');
fprintf('save to %s\n', result_file);