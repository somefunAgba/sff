function damper = const_udbmf5(n)
% const_udbmf5 
%
% Use: const = const_udbmf5(n);
% n: scalar or vector
%
% Uniform Damping constant generation for 
% Five-percent Uniformly Damped Binomial Filters
% - useful for synthesis of damped binomial filters.

arguments
    n, % integer polynomial order or degree
end
%
% as n -> infty, rho -> 1, it is like a circle.

% - test if n is in range
% we set the limit of n as (2^16) which is a big positive number
% for the sake of safety and repeatability
% with respect to computer numerical constraints
err_msg = sprintf("n: expected value range [2^0 ... 2^16].\n");
test = ismember(n, 2^0:2^16);
assert(all(test), err_msg);

% - test if an integer
err_msg = "n: expected an whole number: integer. Rounding n to whole number.)";
test = (round(n) == n);
if ~all(test), warning(err_msg), end
n = round(n);

damper = sqrt( n.*(n-1) - (n-2) ) ./ n;
% damper = sqrt( (n.*n) - (2.*n) + 2 )./n;
%
% damper = sqrt( n.*(n-1) - (n-2) ) / n = sqrt( (n.*n) - (2.*n) + 2 )./n
% if: n == 1, then: damper = 1;
% if: n == 2, then: damper = sqrt(2)/2;
% if: n == 3, then: damper = sqrt(5)/3;
% otherwise:  damper = sqrt( n.*(n-1) - (n-2) ) / n;
% end

end