function [sinr, rate, sum_rate] = calc_sinr_rate(H, X, sigma2)
%CALC_SINR_RATE Compute user SINR and sum-rate for MU-MISO with stream-per-user.
%   Inputs:
%       H      (Ku x Nt)
%       X      (Nt x L) transmit waveform/precoder matrix
%       sigma2 (scalar)
%   Outputs:
%       sinr     (Ku x 1)
%       rate     (Ku x 1)
%       sum_rate (scalar)

[Ku, ~] = size(H);
L = size(X, 2);
Keff = min(Ku, L);
W = X(:, 1:Keff);

sinr = zeros(Ku, 1);
for k = 1:Ku
    hk = H(k, :).';
    sig = abs(hk' * W(:, min(k, Keff)))^2;
    interf = 0;
    for j = 1:Keff
        if j ~= min(k, Keff)
            interf = interf + abs(hk' * W(:, j))^2;
        end
    end
    sinr(k) = sig / (interf + sigma2);
end
rate = log2(1 + sinr);
sum_rate = sum(rate);
end
