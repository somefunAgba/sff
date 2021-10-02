% Savitzky-Golay Filter
% 
clc; clear all; close all;

N = 3;                      % a0,a1,a2,a3 : 3rd order polynomial
M = 4;                      % x[-M],..x[M] . 2M + 1 data

A = zeros(2*M+1,N+1);
for n = -M:M
    A(n+M+1,:) = n.^[0:N];
end

H = (A'*A)^(-1)* A';        % LSE fit matrix

h = H(1,:);                 % S-G filter impulse response (nancausal symmetric FIR)

figure,subplot(2,1,1)
stem([-M:M],h);
title(['Impulse response h[n] of Savitzky-Golay filter of order N = ' num2str(N), ' and window size 2M+1 =  ' , num2str(2*M+1)]);

subplot(2,1,2)
plot(linspace(-1,1,1024), abs(fftshift(fft(h,1024))));
title('Frequency response magnitude of h[n]');


% In terms of your application, I don't have any concrete answers. Much
% depends on the nature of the data (sampling rate, noise ratio, etc.). If
% you use too much smoothing, you'll smear your data or produce aliasing.
% Same thing if you over-fit the data by using high order polynomial
% coefficients, K. In your demo code you should also plot the analytical
% derivatives of the sin function. Then play with different amounts of
% input noise and smoothing filters. Such a tool with known exact answers
% may be helpful if you can approximate aspects of your real data. In
% practice, I try to use as little smoothing as possible in order to
% produce derivatives that aren't too noisy. Often this means a third-order
% polynomial (K = 3) and a window size, F, as small as possible.
% 
% 
function G = sgolayfilt(k,f)
%SGOLAYFILT  Savitzky-Golay differentiation filters
%   G = SGOLAYFILT(K,F) returns the matrix G of differentiation filters. The
%   polynomial order, K, must be a integer less than window size, F, which must
%   be an odd integer. If the polynomial order, K, equals F-1, no smoothing will
%   occur. Each of the K+1 columns of G is a differentiation filter for
%   derivatives of order P-1 where P is the column index.
%   
%   Example:
%       % Smooth noisy sinusoid and calculate first derivative
%       K = 4; F = 55;
%       G = sgolayfilt(K,F);
%       dt = 5e-2; t = 0:dt:4*pi;
%       y = sin(t)+1e-2*randn(size(t));    % Noisy sinusoid
%       yG0 = conv(y,G(:,1).','same');     % 0-th derivative, smoothed
%       yG1 = conv(y,G(:,2).','same')/dt;  % 1-st derivative, smoothed
%       figure; plot(t,y,'k',t,yG0,'b',t,yG1,'r');
%       legend('Noisy','Savitzky-Golay smoothed',...
%              'Savitzky-Golay smoothed first derivative');
%   
%   See also SGOLAY

%   Andrew D. Horchler, horchler @ gmail . com, Created 12-16-11
%   Revision: 1.0, 4-7-16


if nargin < 2
    error('sgolayfilt:TooFewInputs','Not enough input arguments.');
end

if ~isscalar(k) || ~isfinite(k) || ~isreal(k)
    error('sgolayfilt:NonFiniteRealK',...
          'The polynomial order, K, must be a finite real integer.');
end
if ~isscalar(f) || ~isfinite(f) || ~isreal(f)
    error('sgolayfilt:NonFiniteRealF',...
          'The window size, F, must be a finite real integer.');
end

if f < 1 || f ~= floor(f) || mod(f,2) ~= 1
    error('sgolayfilt:InvaildF',...
          'The window size, F, must be an odd integer greater than 0.');
end
if k < 0 || k >= f || k ~= floor(k)
    error('sgolayfilt:InvaildK',...
         ['The polynomial order, K, must be an odd integer greater than the '...
          'window size, F.']);
end

s = vander(0.5*(1-f):0.5*(f-1));
S = s(:,f:-1:f-k);
[~,R] = qr(S,0);
G = S/R/R';
% Savitzky-Golay is a very useful way of combining smoothing and
% differentiation into one operation.
