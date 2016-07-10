%% Task 1: subspace recovery under different intrinsic rank and noise level (Figure 1 in the ICML 2016 paper)

% generate simulation data
diff_rank_rho_gen_data;

% test the algorithms
diff_rank_rho_olrsc;
diff_rank_rho_orpca;
diff_rank_rho_lrr;
diff_rank_rho_pcp;

% collect the results
diff_rank_rho_stat;

% figure
diff_rank_rho_figure;

%% Task 2: convergence rate and computational time (Figure 2 in the ICML 2016 paper)
ev_samples_gen_data;

ev_samples_olrsc;
ev_samples_orpca;
ev_samples_lrr;
ev_samples_pcp;

ev_samples_dictlearn; % make sure you run dictlearn before trying the methods olrsc2 and lrr2
ev_samples_olrsc2;
ev_samples_lrr2;

ev_samples_stat;
ev_samples_figure_ev;
ev_samples_figure_time;

%% Task 3: subspace recovery and clustering with different parameter "d" (Figure 3 in the ICML 2016 paper)
diff_d_gen_data;

diff_d_olrsc;

diff_d_stat;

diff_d_figure_ev;
diff_d_figure_acc;

%% Task 4: subspace clustering on a small subset of mnist
% make sure the label is from 1 to K
mnist_olrsc;
mnist_olrsc_f;
mnist_orpca;
mnist_lrr;
mnist_ssc;