function rho = rhoval(n)
% RHOVAL 
% full interface: rhoval(n)

% Damping factor coefficient generation for Damped Binomial Filters
% - useful for synthesis of damped binomial filters.

% input test
assert(n > 0, "n should be a positive natural number ");
% we set the limit of n as (2^16) which is a big positive number
% for the sake of safety and repeatability
% with respect to computer numerical constraints
assert(n < 65536, "n must not exceed the system's maximum integer");

rho = sqrt( (n*(n-1))-(n-2) ) / n;
% if n == 1
%     sfunc = 1;
% elseif n == 2
%     sfunc = sqrt(2)/2;
% elseif n == 3
%     sfunc = sqrt(5)/3;
% elseif n > 3
%     sfunc = sqrt((n*(n-1))-(n-2))/n; % n^2 - n - 2
% end

end