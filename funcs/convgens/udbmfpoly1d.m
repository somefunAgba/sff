function conv1d_kernel = udbmfpoly1d(n,type,mode)
% UDBMFPOLY_1D
% interface: udbmfpoly1d(n,type,mode)
% - n, 0, 0 : bmf-std
% - n, 0, 1 : bmf-fpud
% - n, 1, 0 : inverse bmf-std
% - n, 1, 1 : inverse bmf-fpud
% Generates the Uniformly-damped Binomial Polynomial Coefficient
% for any non-zero integer order n
% OR
% Generates a 1D convolution kernel or vector of polynomial coeffcients
arguments
    n, % integer polynomial order or degree
    type = 0,
    mode = 1,
end
%% - type = 0 (default) | 1
% if 0: coefficients of the normalized binomial polynomial
% - useful in denominator polynomials of bilinear transform from s-z mapping
% if 1: coefficients of the normalized inverse binomial polynomial
% - useful in numerator polynomials of bilinear transform from s-z mapping
%
%% mode = 1 (default) | damping mode
% uniform damping factor:
% specify uniform damper in case of Somefun's filter
% Somefun's filter (SFF) == FPUDBMF (default)
% if mode = 0, damper can also be: damper = 1 

damper = 1;
if mode == 1
    % Damping value
    damper = const_udbmf5(n);
else
    % round n if real to nearest integer
    n = round(n); 
end

%% computation
% conv1d_kernel: 
% uniformly-damped binomial polynomial coefficients
% also a 1d convolution kernel.

% - initialize the coefficient vector as ones
%   with size (n+1), since k starts from 0 to n
conv1d_kernel = ones(1,n+1);

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
for k = 0:ns
    
    % for k== 0
    if (k == 0)
        conv1d_kernel(k+1) = 1;
    elseif (k == 1)
        % for k == 1
        conv1d_kernel(k+1) = n*damper;
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
        conv1d_kernel(k+1) = val*damper;
    end
    
    if type == 1
        conv1d_kernel(k+1) = (-1)^k * conv1d_kernel(k+1);
    end
    
end

% - symmetry for k > n-k
for k = (ns+1):n % k = ns+1: n
    if type == 0 || flag == 0
        conv1d_kernel(k+1) = conv1d_kernel(n-k+1);
    elseif (type == 1) && (flag == 1)
         conv1d_kernel(k+1) = (-1) * conv1d_kernel(n-k+1);
    end
end

% round to l or 4-d.p: still accurate, and stable
% l = 1;
% conv1d_kernel = round(conv1d_kernel,l);

end
