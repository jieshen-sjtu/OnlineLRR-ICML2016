clear;

config = ev_samples_config();

methods = config.methods_eval;

all_rho = config.rho;
num_rho = length(all_rho);
n = config.n;

num_mth = length(methods);

%% load data
load(config.stat_file_format, 'all_T');

%% figure setting
colors = {'r', 'b', 'g', 'm', 'k', 'k'};
shapes = {'o', 'x', 's', '', '>', ''};
lines = {'', '', '', '--', '', '-'};

x = 1:num_rho;

line_w = 3;
markersz = 14;

strleg = cell(1, num_mth);
for i=1:num_mth
    strleg{i} = upper(methods{i});
end

%% figure
figure;

mean_y = zeros(num_mth, num_rho);
for m=1:num_mth
    mean_y(m, :) = (all_T(:, m))' / 60; % time unit as minute
end

hold on;
grid on;
box on;

for m=1:num_mth
    plot(-5000, -5000, [colors{m} lines{m} shapes{m}], 'linewidth', line_w, 'markersize', markersz);
end

% mark
for m=1:num_mth
    if strcmp(shapes{m}, '')
        continue;
    end
    plot(mean_y(m, :), [colors{m} shapes{m}], 'linewidth', line_w, 'markersize', markersz);
end

% line
for m=1:num_mth
    if strcmp(lines{m}, '')
        continue;
    end
    plot(mean_y(m, :), [colors{m}, lines{m}], 'linewidth', line_w);
    
end


ftsize = 26;
set(gca, 'fontsize', ftsize);
xlabel('Corruption \fontsize{26}\rho');
ylabel('Time (min)');
set(gca, 'xticklabel', all_rho);
set(gca, 'ytick', [5:5:35]);
xlim([1, num_rho]);


hlg = legend(strleg, 'Location','SouthEast');
set(hlg, 'fontsize', 14);

hold off;

% fig_name = sprintf(config.fig_file_time);
% saveas(gcf, fig_name, 'fig' );
% 
% eps_name = sprintf(config.eps_file_time);
% saveas(gcf, eps_name, 'psc2' );
