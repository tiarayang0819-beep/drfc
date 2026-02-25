function sim = calc_radar_similarity(X, radar)
%CALC_RADAR_SIMILARITY Correlation-based radar objective similarity [0,1].
%   Inputs:
%       X     (Nt x L)
%       radar struct with field a_tgt
%   Output:
%       sim   (scalar): normalized projection power ratio onto target steering

R = (X * X') / size(X, 2);
a = radar.a_tgt;
num = real(a' * R * a);
den = real(trace(R)) + eps;
sim = max(0, min(1, num / den));
end
