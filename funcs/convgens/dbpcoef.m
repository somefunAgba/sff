function coeff_kofn = dbpcoef(n,k,type,damper)
% DBCOEF
% interface: dbpcoef(n,k,type,damper)
%
% Generates the k-th Damped Binomial Polynomial Coefficient
% for any non-zero integer order n
% OR
% Generates uniformly damped pascal's triangle or binomial coefficients
% for integer order n
arguments
    n, % integer polynomial order or degree
    k, % coefficient index
    type = 0,
    damper = 1,
end
%% - type = 0 (default) | 1
% if 0: coefficients of the normalized binomial polynomial
% - useful in denominator polynomials of bilinear transform from s-z mapping
% if 1: coefficients of the normalized inverse binomial polynomial
% - useful in numerator polynomials of bilinear transform from s-z mapping
%
%% - uniform damping factor: damper = 1 (default)
% specify uniform damper in case of Somefun's filter
% Somefun's filter (SFF) == FPUDBMF
%
%% n, k | scalars


%% input tests:
% - test if n is in range
% we set the limit of n as (2^16) which is a big positive number
% for the sake of safety and repeatability
% with respect to computer numerical constraints
err_msg = sprintf("n: expected value range [2^0 ... 2^16].\n");
test = ismember(n, 2^0:2^16);
assert(all(test), err_msg);
%
% - test if n is an integer
err_msg = "n: expected an whole number: integer. Rounding n to whole number.)";
test = (round(n) == n);
if ~all(test), warning(err_msg), end
n = round(n);
%
% - test if k is within bounds and is an integer
err_msg = sprintf("k: expected value range [0 .."+num2str(n)+"].\n");
test = ismember(k, 0:n);
assert(test, err_msg);
%
err_msg = "k: expected an whole number: integer. Rounding k to whole number.)";
test = (round(k) == k);
if ~all(test), warning(err_msg), end
k = round(k);


%% computation:
% coeff_kofn: n choose k

% - initialize the coefficient as 1
coeff_kofn = 1;

% - even or odd flag for order n
flag = 0;
% - compute symmetry stop point, ns
if iseven_int(n) % mod(n,2) == 0
    ns = n/2;
    flag = flag + 0; % even
else %if mod(n,2) ~= 0
    ns = (n-1)/2;
    flag = flag + 1; % odd
end

% - symmetry for 0 <= k < = ns
if k >= 0 && k <= ns
    
    % for k== 0
    if (k == 0)
        coeff_kofn = 1;
    elseif (k == 1)
        % for k == 1
        coeff_kofn = n*damper;
    elseif (k > 1)
        % for k > 1
        num = n;
        for i = 1:(k-1)
            num = num * (n - i);
        end
        den = 1;
        for i = 2:k
            den = den * i;
        end
        val = num / den;
        coeff_kofn = val*damper;
    end
    
    if type == 1
        coeff_kofn = (-1)^k * coeff_kofn;
    end
    
end

% - symmetry for k > n-k
if k >= (ns+1) && k <=n % k = ns+1: n
    if type == 0 || flag == 0
        coeff_kofn = dbpcoef(n, (n-k), type, damper);
    elseif (type == 1) && (flag == 1)
        coeff_kofn = (-1) * dbpcoef(n, (n-k), type, damper);
    end
end

end
