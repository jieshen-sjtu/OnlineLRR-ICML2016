clear;

config = mnist_config();

method = 'ssc';

K = config.K;

%% add path
addpath('SSC/');

%% load data
data_file = config.data_file;
load(data_file);

result_file = sprintf(config.result_file_format, method, method);

%% compute Acc for SSC

fprintf('SSC: K = %d ', K);

[p, n] = size(Z);

% The following is exactly what SSC does but we test the running time of SSC and spectral clutering separably.
tic;
Z = DataProjection(Z, 0);
CMat = admmOutlier_mat_func(Z, false, 20);
N = size(Z, 2);
X = CMat(1:N, :);
T = toc;

tic;

Xsym = BuildAdjacency(X);
groups = SpectralClustering(Xsym, K);

Acc = 1 - Misclassification(groups, gt);

T_spec = toc;

fprintf('Acc = %g\n', Acc);

save(result_file, 'Acc', 'T', 'T_spec');
fprintf('save to %s\n', result_file);