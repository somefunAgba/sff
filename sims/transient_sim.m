% transient response.
N = 10;
Tf = 30; % final time

close all;
fig1=figure('Name','impulse');
ax1 = gca;
ax1.XScale='log';

fig2=figure('Name','step');
ax2 = gca;
ax2.XScale='log';

for n=1:N
% Order n filter coefficients
% normalized analog denominator
am = dbpoly_kern(n,0);
% normalized analog numerator
bm= zeros(1,n+1); bm(n+1) = 1;
F = tf(bm,am);

% Step and Impulse Response plot of the UDB low-pass Filter
% with normalized cut-off frequency for values of $n=1$ (blue) to $n=10$
% (brown).
[yi,ti]=impulse(F,Tf);

[ys,ts]=step(F,Tf);

plot(ax1,ti,yi);
% grid(ax1,'on');
cycle3(ax1);
hold(ax1,'on');

plot(ax2,ts,ys);
cycle3(ax2);
% grid(ax2,'on');
hold(ax2,'on');
end

hold(ax1,'off');
hold(ax2,'off');

xlabel(ax1,'Normalized time $t$ (in seconds)','Interpreter','latex')
% ylabel(ax1,'Amplitude')
ylim(ax1,[-0.1 1.05])
xlim(ax1,[0 max(ti)]);

xlabel(ax2,'Normalized time $t$ (in seconds)','Interpreter','latex')
% ylabel(ax2,'Amplitude')
ylim(ax2,[-0.05 1.1])
xlim(ax2,[0 max(ts)]);


% bode(F)
% hold on;
