function Xf = feasibility_projection(X, cfg)
%FEASIBILITY_PROJECTION Sequential projection onto chosen constraint sets.

Xf = proj_power(X, cfg.Ptx);

if cfg.constraint.use_const_modulus
    Xf = proj_const_modulus(Xf, cfg.Ptx, cfg.constraint.const_modulus_mode, cfg.constraint.cm_tol);
    % Re-apply total power projection in case near-CM band mode changed total energy
    Xf = proj_power(Xf, cfg.Ptx);
end

if cfg.constraint.use_per_antenna
    p = sum(abs(Xf).^2, 2);
    scale = min(1, sqrt(cfg.constraint.P_antenna ./ (p + eps)));
    Xf = diag(scale) * Xf;
    Xf = proj_power(Xf, cfg.Ptx);
end
end
