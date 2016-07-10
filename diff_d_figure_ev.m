clear;

config = diff_d_config();

methods = config.methods;

all_d = config.d;
all_rho = config.rho;
n = config.n;

epochs = config.epoch;

measure = 'EV';

% load result
stat_file = sprintf(config.stat_file_format, n);
load(stat_file, 'all_EV');

% figure setting
colors = config.colors;
shapes = config.shapes;
lines = config.lines;

xtick = 1:length(all_rho);
xticklabel = all_rho;

line_w = 4;
markersz = 16;

num_leg = 4;
legstr = cell(1, num_leg);
for i=1:num_leg-1
    legstr{i} = sprintf('d = %d', all_d(i));
end
legstr{num_leg} = ['d \geq ', num2str(all_d(num_leg))];


figure;
hold on;
grid on;
box on;

mean_y = all_EV;

mean_y(:, num_leg) = mean(mean_y(:, num_leg:end), 2);
mean_y = mean_y(:, 1:num_leg);

for m=1:num_leg
    plot(-5000, -5000, [colors{m} shapes{m}], 'linewidth', line_w, 'markersize', markersz);
end

% mark
for m=1:num_leg
    if strcmp(shapes{m}, '')
        continue;
    end
    plot(mean_y(:, m)', [colors{m} shapes{m}], 'linewidth', line_w, 'markersize', markersz);
end

ftsize = 26;
set(gca, 'fontsize', ftsize);

xlabel('Fraction of Corruption \fontsize{32}\rho');
ylabel(measure);
set(gca, 'xtick', xtick, 'xticklabel', xticklabel, 'ytick', [0:0.2:1]);
xlim([1-0.5, length(xtick)+0.5]);

y_max = max(max(mean_y));
if y_max < 0.95
    y_max = 1;
else
    y_max = 1.05;
end
ylim([0, y_max]);


hlg = legend(legstr, 'Location','SouthEast');
set(hlg, 'FontSize', 18);

hold off;

% fig_name = sprintf(config.fig_file_format, measure);
% saveas(gcf, fig_name, 'fig' );
% 
% eps_name = sprintf(config.eps_file_format, measure);
% saveas(gcf, eps_name, 'psc2' );