function cfg = default_config()
%DEFAULT_CONFIG Default experiment configuration for DRFC EFPP-SCA demo.
%   Output:
%       cfg (struct): all simulation, model, and solver options.

cfg.seed = 42;

% Dimensions
cfg.Nt = 8;             % Number of transmit antennas
cfg.L = 16;             % Waveform length (snapshots)
cfg.Ku = 2;             % Number of communication users

% Power/noise
cfg.Ptx = 10;           % Total transmit power budget (linear)
cfg.sigma2 = 1e-2;      % User noise variance

% Radar model
cfg.radar.target_angle_deg = 15;
cfg.radar.sidelobe_angles_deg = -60:5:60;
cfg.radar.sidelobe_exclusion_deg = 10;

% Constraints
cfg.constraint.use_const_modulus = true;
cfg.constraint.const_modulus_mode = 'tight'; % 'tight' or 'band'
cfg.constraint.cm_tol = 0.05;                % Used in 'band' mode
cfg.constraint.use_per_antenna = false;
cfg.constraint.P_antenna = cfg.Ptx / cfg.Nt;

% Initialization
cfg.init.method = 'random_cm'; % random_cm | zf_like

% EFPP-SCA parameters
cfg.alg.max_iter = 80;
cfg.alg.tol_obj = 1e-5;
cfg.alg.tol_violation = 1e-4;
cfg.alg.alpha0 = 0.5;      % gradient step size
cfg.alg.alpha_decay = 0.98;
cfg.alg.rho0 = 1.0;        % initial penalty
cfg.alg.rho_max = 1e4;
cfg.alg.rho_increase = 1.2;
cfg.alg.violation_target = 1e-3;

% Objective tradeoff
cfg.weight.radar = 1.0;
cfg.weight.comm = 0.3;

% Runtime
cfg.use_cvx_if_available = true;
cfg.verbose = true;

% Outputs
cfg.output_dir = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'results');

end
