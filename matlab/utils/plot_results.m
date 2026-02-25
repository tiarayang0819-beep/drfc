function plot_results(out, cfg)
%PLOT_RESULTS Plot and save convergence and metric curves.
%   Inputs:
%       out (struct): solver output with history fields
%       cfg (struct): configuration

if ~exist(cfg.output_dir, 'dir')
    mkdir(cfg.output_dir);
end
iters = 1:numel(out.hist.objective);

save_plot(iters, out.hist.objective, 'Objective', 'objective_vs_iter.png', cfg.output_dir);
save_plot(iters, out.hist.violation, 'Constraint violation', 'violation_vs_iter.png', cfg.output_dir);
save_plot(iters, out.hist.radar_similarity, 'Radar similarity', 'radar_similarity_vs_iter.png', cfg.output_dir);
save_plot(iters, out.hist.sum_rate, 'Sum-rate (bps/Hz)', 'rate_vs_iter.png', cfg.output_dir);

end

function save_plot(x, y, ylab, fname, outdir)
fig = figure('Visible', 'off');
plot(x, y, 'LineWidth', 1.8);
xlabel('Iteration');
ylabel(ylab);
grid on;
title(strrep(fname, '_', '\_'));
saveas(fig, fullfile(outdir, fname));
close(fig);
end
