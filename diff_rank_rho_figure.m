clear;

config = diff_rank_rho_config();

methods = config.methods;

rank_ratio = config.rank_ratio;
all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;
n = config.n;

%% load data
load(sprintf(config.stat_file_format, 'all'), 'all_EV');

%% processing due to the annoying property of imagesc
% we compute the EV map by hand and use image() function
% this ensures each image is rescaled by the same factor
max_val = -1;
min_val = 1;

for m=1:length(methods)
    max_val = max(max_val, max(max(all_EV{m})));
    min_val = min(min_val, min(min(all_EV{m})));
end

max_all = 65;
min_all = 0;

p = (max_all - min_all) / (max_val - min_val);
q = (max_val * min_all - min_val * max_all) / (max_val - min_val);

for m=1:length(methods)
    all_EV{m} = p * all_EV{m} + q;
end


%% figure
txtloc = [0.22 0.25 0. 0.1];

for mth=1:length(methods)
    figure;
    
    y = all_EV{mth};
    
    image(y);
    colormap gray;
    
    
    ftsize = 24;
    set(gca, 'fontsize', ftsize);
    xlabel('Rank / Dimension','FontSize',ftsize);
    ylabel('Corruption','FontSize',ftsize);
    set(gca, 'xtick', [1:3:10]);
    set(gca, 'xtickLabel', 5*[0.01:0.03:0.1]);
    set(gca, 'ytick', [1:2:11]);
    set(gca, 'ytickLabel', [0.5:-0.1:0.0]);
    
    hold on;
    
    str = ['\fontsize{36}', upper(methods{mth})];
    annotation('textbox',...
        txtloc,...
        'String', str, 'FitBoxToText','off','EdgeColor','none',...
        'Color',[1 0 0]);
    
    % manually saving the figures offers a better view
    
%     fig_name = sprintf(config.fig_file_format, n, methods{mth});
%     saveas(gcf, fig_name, 'fig' );
%     
%     eps_name = sprintf(config.eps_file_format, n, methods{mth});
%     saveas(gcf, eps_name, 'psc2' );
    
    hold off;
end
