function rho_new = update_penalty(rho, violation, cfg)
%UPDATE_PENALTY Adaptive penalty update for EFPP outer loop.

if violation > cfg.alg.violation_target
    rho_new = min(cfg.alg.rho_max, rho * cfg.alg.rho_increase);
else
    rho_new = max(cfg.alg.rho0, rho * 0.98);
end
end
