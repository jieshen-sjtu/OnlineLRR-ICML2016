function [ config ] = diff_rank_rho_config()

task = 'diff_rank_rho';

config.methods = {'olrsc', 'lrr', 'orpca', 'pcp'};

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

% format: rank, rho, trial
config.data_file_format = [config.data_dir task '_data_rank_%d_rho_%g_rep_%d.mat'];
% format: method method rank rho repetition
config.result_file_format = [config.result_dir '%s/' task '_result_%s_rank_%d_rho_%g_rep_%d.mat'];
% format: task
config.stat_file_format = [config.stat_dir task '_stat_%s.mat'];

%% figure
config.colors = {'r', 'b', 'k', 'g', 'm', 'c', 'y'};
config.shapes = {'', '', '>', '', 'o', '.', '^'};
config.lines = {'-', '--', '-', '-', '-', '-', '-'};

% this plots a matrix for different methods, with x/y axis = rank_ratio/rho
% format: sample size, method
config.fig_file_format = [config.figure_dir task '_n_%d_%s.fig'];
config.eps_file_format = [config.figure_dir task '_n_%d_%s.eps'];


config.p = 100; % ambient dimension
config.K = 4; % number of subspaces

config.all_n = 1000 * ones(config.K, 1); % sample size for each subspace
config.rank_ratio = 0.01:0.01:0.1; % different rank of small subspace
config.all_d = round(config.p * ones(config.K, 1) * config.rank_ratio); % rank for the union of subspace

config.rho = 0:0.05:0.5; % different noise level

config.n = sum(config.all_n);

config.d = sum(config.all_d);

config.epoch = 1;
config.repetitions = 1:10;

end
