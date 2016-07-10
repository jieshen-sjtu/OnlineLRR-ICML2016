function [ config ] = mnist_all_config()

task = 'mnist';
config.K = 10; % number of classes. label from 1 to 10

config.methods = {'olrsc', 'olrsc-f', 'orpca', 'lrr', 'ssc'};

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

% format: rank_ratio rho repetition
config.data_file = [config.data_dir task '.mat'];
% format: method method
config.result_file_format = [config.result_dir '%s/' task '_result_%s.mat'];

config.epoch = 2;

end
