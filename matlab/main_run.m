function out = main_run()
%MAIN_RUN Entry script for DRFC EFPP-SCA reproduction framework.
%   Usage:
%       out = main_run();

root = fileparts(mfilename('fullpath'));
addpath(genpath(root));

cfg = default_config();
set_seed(cfg.seed);

if ~exist(cfg.output_dir, 'dir')
    mkdir(cfg.output_dir);
end

model.H = gen_channels(cfg);
model.radar = gen_radar_target(cfg);
model.noise_power = cfg.sigma2;

out = efpp_sca_solve(model, cfg);
out.cfg = cfg;
out.model = model;

plot_results(out, cfg);
save(fullfile(cfg.output_dir, 'run_output.mat'), 'out');

fprintf('Finished in %d iterations. Converged=%d\n', out.iter, out.converged);
fprintf('Results saved to %s\n', cfg.output_dir);
end
