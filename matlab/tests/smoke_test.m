function smoke_test()
%SMOKE_TEST Quick end-to-end test for the MATLAB DRFC framework.

root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(root));

cfg = default_config();
cfg.Nt = 8;
cfg.L = 16;
cfg.Ku = 2;
cfg.alg.max_iter = 20;
cfg.verbose = false;

set_seed(cfg.seed);
model.H = gen_channels(cfg);
model.radar = gen_radar_target(cfg);

out = efpp_sca_solve(model, cfg);
assert(~isempty(out.Xbest), 'Xbest is empty');
assert(all(isfinite(out.hist.objective)), 'Non-finite objective found');
assert(out.iter <= cfg.alg.max_iter, 'Iteration count exceeds max_iter');

fprintf('smoke_test passed: iter=%d, final_obj=%.4e, final_violation=%.3e\n', ...
    out.iter, out.hist.objective(end), out.hist.violation(end));
end
