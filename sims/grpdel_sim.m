freqw = 0:0.1*pi/2:50*2*pi;
wc = 2*pi*2.5;
norm_freqw = freqw./wc;
wlog = log10(norm_freqw);

close all
figure;
% Plot of the Group delay (in seconds) of a uniformly-damped binomial low-pass Filter
% with normalized cut-off frequency for values of $n=1$ (blue) to to $n=5$
% (green).

for n = 1:10
    tau_g = grpdel(norm_freqw,1,n);
    
    semilogx(norm_freqw,tau_g);
    cycle3;
    hold on;
%   pause(0.1);
    ax = gca;
    ax.MinorGridLineStyle = 'none';
    ax.Box = 'on';
end
hold off;
grid on;
% ylim([-.05 1.05]);
% xlim([0 inf]);
xlabel('Normalized frequency $\omega$ (in radians)','Interpreter','latex')
% ylabel('Group Delay')
xlim([0 10*max(wlog)]);
xlim([0 10*max(wlog)]);