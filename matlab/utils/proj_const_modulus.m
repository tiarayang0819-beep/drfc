function Xcm = proj_const_modulus(X, Ptx, mode, cm_tol)
%PROJ_CONST_MODULUS Project matrix to constant / near-constant modulus set.
%   Inputs:
%       X      (Nt x L complex)
%       Ptx    (scalar): used to set nominal modulus c = sqrt(Ptx/(Nt*L))
%       mode   (char): 'tight' for exact modulus, 'band' for [c*(1-cm_tol), c*(1+cm_tol)]
%       cm_tol (scalar): relative tolerance used in band mode
%   Output:
%       Xcm    (Nt x L complex)

[Nt, L] = size(X);
c = sqrt(Ptx / (Nt * L));
phase = exp(1j * angle(X + 1e-12));
amp = abs(X);

switch lower(mode)
    case 'tight'
        amp_proj = c * ones(size(amp));
    case 'band'
        lo = c * (1 - cm_tol);
        hi = c * (1 + cm_tol);
        amp_proj = min(max(amp, lo), hi);
    otherwise
        error('Unknown const modulus mode: %s', mode);
end

Xcm = amp_proj .* phase;
end
