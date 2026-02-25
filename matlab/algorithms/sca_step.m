function Xcand = sca_step(Xk, sur, model, cfg, rho)
%SCA_STEP Solve one SCA subproblem (CVX if available, else projected gradient).
%   Inputs:
%       Xk, sur, model, cfg, rho
%   Output:
%       Xcand

use_cvx = cfg.use_cvx_if_available && exist('cvx_begin', 'file') == 2; %#ok<EXIST>

if use_cvx
    % CVX branch: quadratic proximal step around first-order model
    [Nt, L] = size(Xk);
    G = sur.grad;
    cvx_begin quiet
        variable Xr(Nt, L) complex
        minimize(real(sum(sum(conj(G) .* (Xr - Xk)))) + (1/(2*sur.alpha)) * square_pos(norm(Xr - Xk, 'fro')))
        subject to
            norm(Xr, 'fro') <= sqrt(cfg.Ptx);
    cvx_end
    Xcand = Xr;
else
    % Fallback: one projected gradient step
    step = sur.alpha / (1 + 0.1 * rho);
    Xcand = Xk - step * sur.grad;
    Xcand = proj_power(Xcand, cfg.Ptx);
end

% soft communication shaping
H = model.H;
Xcand = Xcand - 0.01 * (H' * (H * Xcand));
end
