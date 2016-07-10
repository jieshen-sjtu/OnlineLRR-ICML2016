function [U, V, E] = gen_union_subspace(p, all_d, all_n, rho)

mu = 0;
sigma = sqrt(1);

% number of subspaces
k = length(all_d);

U = cell(1, k);
V = cell(1, k);

% generate a complete subspace
U_all = orth(mu + sigma * randn(p, p));

start_idx = 1;

for kidx=1:k
    d = all_d(kidx);
    n = all_n(kidx);
    end_idx = start_idx + d - 1;
    
    if end_idx > p
        error('cannot produce disjoint subspaces');
    end
    
    U{kidx} = U_all(:, start_idx:end_idx); % this ensures the disjointness of subspaces
    V{kidx} = mu + sigma * randn(n, d);
    start_idx = end_idx + 1;
end

num_samples = sum(all_n);

num_elements = p * num_samples;
temp = randperm(num_elements) ;
numCorruptedEntries = round(rho * num_elements) ;
corruptedPositions = temp(1:numCorruptedEntries) ;
E = zeros(p, num_samples);
E(corruptedPositions) = 20 *(rand(numCorruptedEntries, 1) - 0.5) ;

end