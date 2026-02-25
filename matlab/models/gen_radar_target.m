function radar = gen_radar_target(cfg)
%GEN_RADAR_TARGET Build desired radar beampattern template.
%   Output radar struct fields:
%       a_tgt   (Nt x 1): target steering vector
%       A_sl    (Nt x Ns): sidelobe steering vectors
%       mask_sl (1 x Ns logical): true where sidelobe penalties apply

angles = cfg.radar.sidelobe_angles_deg;
a_tgt = steering_vec_ula(cfg.Nt, cfg.radar.target_angle_deg);
A = steering_vec_ula(cfg.Nt, angles);
mask_sl = abs(angles - cfg.radar.target_angle_deg) >= cfg.radar.sidelobe_exclusion_deg;

radar.a_tgt = a_tgt;
radar.A_grid = A;
radar.angles = angles;
radar.mask_sl = mask_sl;
radar.A_sl = A(:, mask_sl);
end
