clear;

config = diff_rank_rho_config();

methods = config.methods;

all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;
n = config.n;

%% collect all averaged data
all_data = zeros(length(methods), length(all_d), length(all_rho), n);

for mth = 1:length(methods)
    fprintf('loading data for %s\n', methods{mth});
    
    for j=1:length(all_d)
        d = all_d(j);
        
        for i=1:length(all_rho)
            rho = all_rho(i);
            
            ev = zeros(1, n);
            for k=1:length(all_rep)
                rep = all_rep(k);
                
                result_file = sprintf(config.result_file_format, methods{mth}, methods{mth}, d, rho, rep);
                load(result_file, 'EV');
                
                ev = ev + EV;
            end
            
            ev = ev / length(all_rep);
            
            all_data(mth, j, i, :) = ev;
        end
    end
end

%% final EV w.r.t. rho and rank
%{rho * rank}
all_EV = cell(1, length(methods));

for mth = 1:length(methods)
    all_EV{mth} = zeros(length(all_rho), length(all_d));
    
    for j=1:length(all_d)
        for i=1:length(all_rho)
            
            EV = all_data(mth, j, i, :);
            
            ev = EV(end);
            
            all_EV{mth}(length(all_rho) + 1 - i, j) = ev;
        end
    end
end

stat_file = sprintf(config.stat_file_format, 'all');
save(stat_file, 'all_EV');
fprintf('save to %s\n', stat_file);
