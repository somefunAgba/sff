% freqw = -50*2*pi:1*pi/2:50*2*pi;
freqw = 0:0.1*pi/2:50*2*pi;
wc = 2*pi*2.5;
norm_freqw = freqw./wc;
wlog = log10(norm_freqw);

close all
fig1=figure('Name','phase');
ax1 = gca;
ax1.XScale='log';

fig2=figure('Name','phasedelay');
ax2 = gca;
ax2.XScale='log';

for n = 1:10 % 1,%2 %3 %5
[phase, tau_p, inum, rden] = phasedel(norm_freqw,1,n);

% Plot of the Phase response (in radians) of a UDB low-pass Filter
% with normalized cut-off frequency for values of $n=1$ (blue) to to $n=5$
% (green).

hold(ax1,'on');
plot(ax1,norm_freqw,phase); 
cycle3(ax1);
grid(ax1,'on');
hold(ax1,'off');
% pause(0.1);
ax1.MinorGridLineStyle = 'none';
ax1.Box = 'on';

% Plot of the Phase delay (in seconds) of a UDB low-pass Filter
% with normalized cut-off frequency for values of $n=1$ (blue) to to $n=5$
% (green).
hold(ax2,'on');
plot(ax2,norm_freqw,tau_p);
cycle3(ax2);
grid(ax2,'on');
hold(ax2,'off');
% pause(0.1);
ax2.MinorGridLineStyle = 'none';
ax2.Box = 'on';

end
xlabel(ax1,'Normalized frequency $\omega$ (in radians)','Interpreter','latex')
% ylabel(ax1,'Phase')
xlabel(ax2,'Normalized frequency $\omega$ (in radians)','Interpreter','latex')
% ylabel(ax2,'Phase Delay')
xlim(ax1,[0 10*max(wlog)]);
ylim(ax1,[-inf 0.5]);
xlim(ax2,[0 10*max(wlog)]);