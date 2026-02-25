function log_iter(k, hist)
%LOG_ITER Print one iteration summary.
%   Inputs:
%       k (int): iteration index
%       hist (struct): history struct with fields objective, violation, rho, rate, radar_similarity

fprintf(['Iter %3d | obj: %.4e | viol: %.3e | rho: %.3e | ' ...
    'rad: %.4f | rate: %.4f\n'], ...
    k, hist.objective(k), hist.violation(k), hist.rho(k), ...
    hist.radar_similarity(k), hist.sum_rate(k));
end
