function a = steering_vec_ula(Nt, angle_deg, d_lambda)
%STEERING_VEC_ULA ULA steering vector with half-wavelength default spacing.
%   Inputs:
%       Nt        (int): antenna number
%       angle_deg (scalar or vector): angles in degree
%       d_lambda  (scalar): spacing / wavelength
%   Output:
%       a (Nt x numel(angle_deg) complex)

if nargin < 3
    d_lambda = 0.5;
end
angles = deg2rad(angle_deg(:).');
n = (0:Nt-1).';
a = exp(1j * 2 * pi * d_lambda * n * sin(angles));
a = a ./ sqrt(Nt);
end
