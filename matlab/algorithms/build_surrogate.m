function sur = build_surrogate(Xk, model, cfg)
%BUILD_SURROGATE Build first-order surrogate quantities at current point.
%   Inputs:
%       Xk    (Nt x L): current iterate
%       model (struct): contains H, radar
%       cfg   (struct)
%   Output:
%       sur   (struct): surrogate data including gradient and step size

H = model.H;
a = model.radar.a_tgt;
A_sl = model.radar.A_sl;
R = (Xk * Xk') / size(Xk, 2);

% Radar gradient: maximize target power and suppress sidelobe power
Gt = -(a * a') * Xk / size(Xk, 2);
if ~isempty(A_sl)
    Gsl = (A_sl * A_sl') * Xk / size(Xk, 2);
else
    Gsl = 0;
end

% Communication gradient: maximize channel energy approximation
Gc = -(H' * H) * Xk / size(Xk, 2);

grad_obj = cfg.weight.radar * (Gt + 0.2 * Gsl) + cfg.weight.comm * Gc;

viol = calc_constraint_violation(Xk, cfg);
grad_pen = zeros(size(Xk));
if viol.power > 0
    grad_pen = grad_pen + 2 * Xk;
end
if cfg.constraint.use_const_modulus
    c = sqrt(cfg.Ptx / numel(Xk));
    amp = abs(Xk) + 1e-12;
    grad_pen = grad_pen + ((amp - c) ./ amp) .* Xk;
end

sur.grad = grad_obj + cfg.alg.rho0 * grad_pen; %#ok<STRNU>
sur.alpha = cfg.alg.alpha0;
sur.R = R;
end
