function bpck = bpc_skern(n,k,varargin)
% BPC_KERN  
% full interface: bpc_kern(n,type,rho)
% Generating Function for Binomial Polynomial Coefficients
% of any real non-zero order n


% Generates Pascal-Triangle's Binomial Coefficients
% for integer order n

% type = 0
% Coefficients of the normalized Binomial Transform
% - useful in denominator polynomials of bilinear transform from s2z
% type = 1
% Coefficients of the normalized Inverse Binomial Transform
% - useful in numerator polynomials of bilinear transform from s2z
% Damping factor inclusion for Somefun Filters
% - useful for coefficients of somefun filters.

assert(nargin > 0 && nargin < 5, "min of 1, max of 4 arguments")
if nargin == 2
    type = 0; % 0 - default bin, 1 - bin. inverse
    rho = 1; % default damping factor
elseif nargin == 3
    type = varargin{1};
    rho = 1; % default damping factor
elseif nargin > 3
    type = varargin{1};
    rho = varargin{2}; % default damping factor
end
% input test
assert(n > 0, "should be a positive natural number ");
% we set the limit of n as (2^16) which is a big positive number
% for the sake of safety and repeatability
% with respect to computer numerical constraints
assert(n < 65536, "must not exceed the system's maximum integer");

assert (k <= n && k >= 0, "k must be within limits");

% initialize a vector of ones with size (n+1)
bpck = 1;

flag = 0; % is it even or odd
% compute symmetry stop point
if mod(n,2) == 0
    % if even
    ns = n/2;
    flag = 0; % even
elseif mod(n,2) ~= 0
    % if odd
    ns = (n-1)/2;
    flag = 1; % odd
end

if k >= 0 && k <= ns
    
    % for k== 0
    if (k == 0)
        bpck = 1;
    elseif (k == 1)
        % for k == 1
        bpck = n*rho;
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
        bpck = val*rho;
    end
    
    if type == 1
        bpck = (-1)^k * bpck;
    end
    
end

% symmetry for k > n-k
if k >= (ns+1) && k <=n % k = ns+1: n
    if type == 0 || flag == 0
        bpck = bpc_skern(n,n-k,type,rho);
    elseif (type == 1) && (flag == 1)
         bpck = (-1) * bpc_skern(n,n-k,type,rho);
    end
end

end
