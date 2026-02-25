function set_seed(seed)
%SET_SEED Set reproducible RNG seed.
%   Input:
%       seed (scalar): random seed.

rng(seed, 'twister');
end
