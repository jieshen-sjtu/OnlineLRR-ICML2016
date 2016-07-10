clear;

config = ev_samples_config();

methods = config.methods_eval;

all_rho = config.rho;
all_rep = config.repetitions;

%% data: method * rho * n

all_EV = cell(1, length(methods));
all_T = zeros(length(all_rho), length(methods));

for mth = 1:length(methods)
    all_EV{mth} = zeros(length(all_rho), config.n);
    
    for i=1:length(all_rho)
        rho = all_rho(i);
        
        mean_EV = zeros(1, config.n);
        mean_T = 0;
        
        for k=1:length(all_rep)
            rep = all_rep(k);
            
            result_file = sprintf(config.result_file_format, methods{mth}, methods{mth}, config.d, rho, rep);
            load(result_file, 'EV', 'T');
            
            mean_EV = mean_EV + EV;
            mean_T = mean_T + T;
        end
        
        mean_EV = mean_EV / length(all_rep);
        mean_T = mean_T / length(all_rep);
        
        all_EV{mth}(i, :) = mean_EV;
        all_T(i, mth) = mean_T;
    end
end

save(config.stat_file_format, 'all_EV', 'all_T');
fprintf('save to %s\n', config.stat_file_format);
