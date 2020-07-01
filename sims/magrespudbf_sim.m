freqw = 0:0.1*pi/2:50*2*pi;
wc = 2*pi*2.5;
norm_freqw = freqw./wc;

close all
figure;

for n=1:10
    
[msq1,m1,msq2,m2,msq3,m3]=magresp_udbf(norm_freqw,1,n);
dB = 20*log10(msq1);
wlog = log10(norm_freqw);

% Plot of the Magnitude Response (in dB) of a UDB low-pass Filter
% with normalized cut-off frequency for orders $n=1$ (blue) to to $n=10$
% (brown).
semilogx(norm_freqw,dB); 
ylim([-150 5])
xlim([0 10*max(wlog)]);


% Plot of the Magnitude Response of a UDB low-pass Filter
% with normalized cut-off frequency for orders $n=1$ (blue) to to $n=10$
% (brown).
% semilogx(norm_freqw,m1); 
% ylim([-.02 1.02]);
% xlim([0 10*max(wlog)]);

ax = gca;
ax.MinorGridLineStyle = 'none';
hold on; 
cycle3;

end

xlabel('Normalized frequency $\omega$ (in radians)','Interpreter','latex')
% ylabel('Magnitude')
grid on;
