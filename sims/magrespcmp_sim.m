freqw = 0:0.01*pi/2:50*2*pi;
wc = 2*pi*2.5;
norm_freqw = freqw./wc;

close all
% Comparison Plot of the Magnitude Response of the UDBF(blue), BWF(red), 
% and BMF(brown) with normalized cut-off frequency for 
% orders $n=1$ to to $n=4$.

N=4;
for n = 1:N
fig(n)=figure('Name',['n-',num2str(n)]); %#ok<SAGROW>
axvec(n) = gca; %#ok<SAGROW>
end

%%

for n=1:N
    
[msq1,m1,msq2,m2,msq3,m3]=magresp_udbf(norm_freqw,1,n);
dB = 20*log10(msq1);
wlog = log10(norm_freqw);

% semilogx(norm_freqw,dB); 
% ylim([-inf 20])
% xlim([0 10*max(wlog)]);

axvec(n).XScale = 'log';
% ax = axvec(n);
hold(axvec(n), 'on');
semilogx(axvec(n),norm_freqw,m1); 
semilogx(axvec(n),norm_freqw,m2);
semilogx(axvec(n),norm_freqw,m3);
hold(axvec(n), 'off');

% grid(axvec(n),'off');

ylim(axvec(n),[-.05 1.05]);
xlim(axvec(n),[0 10*max(wlog)]);
cycle3(axvec(n));
axvec(n).Box = 'on';

% pause(1);
xlabel(axvec(n),'Normalized frequency $\omega$ (in radians)','Interpreter','latex')
% ylabel(axvec(n),'Magnitude')
end

% clc


