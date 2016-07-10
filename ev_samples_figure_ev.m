clear;

config = ev_samples_config();

methods = config.methods_eval;

all_rho = config.rho;
n = config.n;

num_mth = length(methods);

%% load data
load(config.stat_file_format, 'all_EV');

%% figure setting
colors = config.colors;
shapes = config.shapes;
lines = config.lines;

pointSpace = n / 20;
ind = cell(1, num_mth);
for m=1:num_mth
    ind{m} = 1:pointSpace:n;
end
ind{1} = [1:100:n n];
ind{2} = [1:30 100:100:n n];

x = 1:n;

line_w = 3;

strleg = cell(1, num_mth);
for mth=1:num_mth
    strleg{mth} = upper(methods{mth});
end

ftleg = [24 24 22 15];

for i=1:length(all_rho)
    rho = all_rho(i);
    
    figure;
    
    hold on;
    grid on;
    box on;
    
    mean_y = zeros(num_mth, n);
    for m=1:num_mth
        mean_y(m, :) = all_EV{m}(i, :);
    end
    
    for m=1:num_mth
        plot(-5000, -5000, [colors{m} lines{m} shapes{m}], 'linewidth', line_w);
    end
    
    % mark
    for m=1:num_mth
        if strcmp(shapes{m}, '')
            continue;
        end
        plot(x(ind{m}), mean_y(m, ind{m}), [colors{m} shapes{m}], 'linewidth', line_w);
    end
    
    % line
    for m=1:num_mth
        if m==2 || m==1
            plot(x(ind{m}), mean_y(m, ind{m}), [colors{m}, lines{m}], 'linewidth', line_w);
        else
            plot(x, mean_y(m, :), [colors{m}, lines{m}], 'linewidth', line_w);
        end
    end
    
    
    ftsize = 26;
    set(gca, 'fontsize', ftsize);
    xlabel('Number of Samples (x10^3)');
    ylabel('EV');
    set(gca,'FontSize',ftsize, 'xtick', [(n/5):(n/5):n], 'xticklabel', (n/5000):(n/5000):(n/1000));
    set(gca, 'ytick', [0:0.2:1]);
    xlim([-100, n]);
    
    y_max = max(max(mean_y));
    if y_max < 0.95
        y_max = 1;
    else
        y_max = 1.05;
    end
    ylim([0, y_max]);
    
    hlg = legend(strleg, 'Location','SouthEast');
    set(hlg, 'FontSize', ftleg(i));
    
    str = ['\fontsize{34}\rho=\fontsize{28}', num2str(rho)];
    annotation('textbox',...
        [0.28 0.38 0.2 0.1],...
        'String', str, 'FitBoxToText','off','EdgeColor', 'none', 'FontWeight', 'bold',...
        'Color',[1 0 0]);
    
    hold off;
    
%     fig_name = sprintf(config.fig_file_format, rho);
%     saveas(gcf, fig_name, 'fig' );
%     
%     eps_name = sprintf(config.eps_file_format, rho);
%     saveas(gcf, eps_name, 'psc2' );
    
end
