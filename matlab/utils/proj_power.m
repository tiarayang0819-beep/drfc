function Xp = proj_power(X, Ptx)
%PROJ_POWER Project matrix onto total power ball ||X||_F^2 <= Ptx.
%   Inputs:
%       X   (Nt x L complex)
%       Ptx (scalar)
%   Output:
%       Xp  (Nt x L complex)

pow = norm(X, 'fro')^2;
if pow <= Ptx || pow == 0
    Xp = X;
else
    Xp = X * sqrt(Ptx / pow);
end
end
