function dbpoly = dbpoly_kern(n,varargin)
% BPC_KERN  
% Generating Function for Coefficients of a 
% Damped Binomial Polynomial in vector form
% of any real non-zero order n

% Interface: dbpoly_kern(n,type,mode)


% Generates Damped Pascal-Triangle's Binomial Coefficients
% for integer order n

% type = 0
% Coefficients of the normalized Binomial Transform
% - useful in denominator polynomials of bilinear transform from s2z
% type = 1
% Coefficients of the normalized Inverse Binomial Transform
% - useful in numerator polynomials of bilinear transform from s2z
% Damping factor inclusion for Somefun Filters
% - useful for coefficients of somefun filters.

% mode = 1, rho = damped.
% mode = 0, rho = 1;

assert(nargin > 0 && nargin < 4, "min of 1, max of 3 arguments")
if nargin == 1
    type = 0; % 0 - default bin, 1 - bin. inverse
    mode = 1; % default damping mode
elseif nargin == 2
    type = varargin{1};
    mode = 1; % default damping mode
else
    type = varargin{1};
    mode = varargin{2}; % default damping factor
end
% input test
assert(n > 0, "should be a positive natural number ");
% we set the limit of n as (2^16) which is a big positive number
% for the sake of safety and repeatability
% with respect to computer numerical constraints
assert(n < 65536, "must not exceed the system's maximum integer");

rho = 1;
if mode == 1
    % Damping value
    rho = rhoval(n);
end
% initialize a vector of ones with size (n+1)
dbpoly = ones(1,n+1);

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

for k = 0:ns
    
    % for k== 0
    if (k == 0)
        dbpoly(k+1) = 1;
    elseif (k == 1)
        % for k == 1
        dbpoly(k+1) = n*rho;
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
        dbpoly(k+1) = val*rho;
    end
    
    if type == 1
        dbpoly(k+1) = (-1)^k * dbpoly(k+1);
    end
    
end

% symmetry for k > n-k
for k = (ns+1):n % k = ns+1: n
    if type == 0 || flag == 0
        dbpoly(k+1) = dbpoly(n-k+1);
    elseif (type == 1) && (flag == 1)
         dbpoly(k+1) = (-1) * dbpoly(n-k+1);
    end
end

end
