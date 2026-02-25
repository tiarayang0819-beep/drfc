function out = efpp_sca_solve(model, cfg)
%EFPP_SCA_SOLVE Penalized feasibility + SCA main solver.
%   Output out fields:
%       Xbest, hist, converged, iter

Nt = cfg.Nt; L = cfg.L;

switch lower(cfg.init.method)
    case 'random_cm'
        X = (randn(Nt, L) + 1j * randn(Nt, L)) / sqrt(2);
        X = feasibility_projection(X, cfg);
    case 'zf_like'
        H = model.H;
        W = H' / (H * H' + 1e-3 * eye(size(H, 1)));
        X = repmat(W(:, 1:min(size(W,2), L)), 1, ceil(L / size(W,2)));
        X = X(:, 1:L);
        X = feasibility_projection(X, cfg);
    otherwise
        error('Unknown init method: %s', cfg.init.method);
end

Kmax = cfg.alg.max_iter;
hist.objective = zeros(Kmax, 1);
hist.violation = zeros(Kmax, 1);
hist.rho = zeros(Kmax, 1);
hist.radar_similarity = zeros(Kmax, 1);
hist.sum_rate = zeros(Kmax, 1);

rho = cfg.alg.rho0;
obj_prev = inf;
converged = false;

for k = 1:Kmax
    sur = build_surrogate(X, model, cfg);
    Xcand = sca_step(X, sur, model, cfg, rho);
    Xnew = feasibility_projection(Xcand, cfg);

    % Metrics
    sim = calc_radar_similarity(Xnew, model.radar);
    [~, ~, sum_rate] = calc_sinr_rate(model.H, Xnew, cfg.sigma2);
    v = calc_constraint_violation(Xnew, cfg);

    obj = -cfg.weight.radar * sim - cfg.weight.comm * sum_rate + rho * v.total;

    hist.objective(k) = obj;
    hist.violation(k) = v.total;
    hist.rho(k) = rho;
    hist.radar_similarity(k) = sim;
    hist.sum_rate(k) = sum_rate;

    if cfg.verbose
        log_iter(k, hist);
    end

    rel_change = abs(obj - obj_prev) / max(1, abs(obj_prev));
    if (rel_change < cfg.alg.tol_obj) || (v.total < cfg.alg.tol_violation)
        converged = true;
        X = Xnew;
        break;
    end

    rho = update_penalty(rho, v.total, cfg);
    cfg.alg.alpha0 = cfg.alg.alpha0 * cfg.alg.alpha_decay;
    X = Xnew;
    obj_prev = obj;
end

iter = k;
fields = fieldnames(hist);
for i = 1:numel(fields)
    hist.(fields{i}) = hist.(fields{i})(1:iter);
end

out.Xbest = X;
out.hist = hist;
out.converged = converged;
out.iter = iter;
end
