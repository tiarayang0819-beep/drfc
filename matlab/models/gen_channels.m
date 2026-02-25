function H = gen_channels(cfg)
%GEN_CHANNELS Generate MU-MISO downlink channels.
%   Output:
%       H (Ku x Nt complex): user channel matrix, each row is one user

H = (randn(cfg.Ku, cfg.Nt) + 1j * randn(cfg.Ku, cfg.Nt)) / sqrt(2);
end
