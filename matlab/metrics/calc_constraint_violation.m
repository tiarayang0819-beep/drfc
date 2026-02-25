function v = calc_constraint_violation(X, cfg)
%CALC_CONSTRAINT_VIOLATION Aggregate normalized constraint violations.

pow_v = max(0, norm(X, 'fro')^2 - cfg.Ptx) / max(cfg.Ptx, eps);

if cfg.constraint.use_const_modulus
    c = sqrt(cfg.Ptx / numel(X));
    amp = abs(X);
    switch lower(cfg.constraint.const_modulus_mode)
        case 'tight'
            cm_v = mean(abs(amp(:) - c)) / max(c, eps);
        case 'band'
            lo = c * (1 - cfg.constraint.cm_tol);
            hi = c * (1 + cfg.constraint.cm_tol);
            cm_v = mean(max(0, amp(:) - hi) + max(0, lo - amp(:))) / max(c, eps);
        otherwise
            cm_v = 0;
    end
else
    cm_v = 0;
end

if cfg.constraint.use_per_antenna
    pa = sum(abs(X).^2, 2);
    pa_v = mean(max(0, pa - cfg.constraint.P_antenna)) / max(cfg.constraint.P_antenna, eps);
else
    pa_v = 0;
end

v.total = pow_v + cm_v + pa_v;
v.power = pow_v;
v.const_modulus = cm_v;
v.per_antenna = pa_v;
end
