function [ config ] = ev_samples_config()

task = 'ev_samples';

config.methods = {'olrsc', 'orpca', 'lrr', 'pcp', 'olrsc2', 'lrr2', 'dictlearn'}; % dictlearn gives 'Y' for LRR2 and OLRSC2
config.methods_eval = {'olrsc', 'olrsc2', 'orpca', 'lrr', 'lrr2', 'pcp'};

root_dir = ['ExpData/' task '/'];
if ~exist(root_dir, 'dir')
    mkdir(root_dir)
end

config.data_dir = [root_dir 'data/'];
if ~exist(config.data_dir, 'dir')
    mkdir(config.data_dir);
end

config.result_dir = [root_dir 'result/'];
if ~exist(config.result_dir, 'dir')
    mkdir(config.result_dir);
end

config.sub_result_dirs = cell(1, length(config.methods));
for i=1:length(config.methods)
    config.sub_result_dirs{i} = [config.result_dir config.methods{i} '/'];
    if ~exist(config.sub_result_dirs{i}, 'dir')
        mkdir(config.sub_result_dirs{i});
    end
end

config.stat_dir = [root_dir 'stat/'];
if ~exist(config.stat_dir, 'dir')
    mkdir(config.stat_dir);
end

config.figure_dir = [root_dir 'figure/'];
if ~exist(config.figure_dir, 'dir')
    mkdir(config.figure_dir);
end

% format: rank rho repetition
config.data_file_format = [config.data_dir task '_data_rank_%d_rho_%g_rep_%d.mat'];
% format: method method rank rho repetition
config.result_file_format = [config.result_dir '%s/' task '_result_%s_rank_%d_rho_%g_rep_%d.mat'];

config.stat_file_format = [config.stat_dir task '_stat.mat'];

%% figure
config.colors = {'r', 'b', 'g', 'm', 'k', 'k'};
config.shapes = {'', '', '', '', '>', ''};
config.lines = {'-', '-', '-', '--', '', '-'};

% format: rho
config.fig_file_format = [config.figure_dir task '_rank_rho_%g.fig'];
config.eps_file_format = [config.figure_dir task '_rank_rho_%g.eps'];


config.p = 1000; % ambient dimension
config.K = 4; % number of subspaces

config.all_n = 5000 * ones(config.K, 1); % 5000 samples in each small subspace
config.rank_ratio = 0.025; % for each small subspace, true rank is 1000 * 0.025 = 25
config.all_d = round(config.p * ones(config.K, 1) * config.rank_ratio); % rank of small subspace

config.rho = [0.01, 0.1, 0.3, 0.5];

config.n = sum(config.all_n);

config.d = sum(config.all_d);

config.repetitions = 1:10;

end
