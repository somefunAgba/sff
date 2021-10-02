% transient response.
N = 10;
Tf = 30; % final time

close all;
fig1=figure('Name','impulse');
ax1 = gca;
% ax1.XScale='log';

fig2=figure('Name','step');
ax2 = gca;
% ax2.XScale='log';
Yi=[]; Ys=[];

for n=1:N
% - order n filter coefficients
% normalized analog denominator
am = udbmfpoly1d(n,0,1);
% normalized analog numerator
bm = flip(eye(1,n+1),2); % rot90(eye(1,n+1),2)
F = tf(bm,am);

% -step and impulse response plot
% with normalized cut-off frequency for values of $n=1$ (blue) to $n=10$
% (brown).
[yi,ti]=impulse(F,Tf);
% Yi=[Yi; yi];

[ys,ts]=step(F,Tf);
% Ys=[Ys; ys];

plot(ax1,ti,yi);
% grid(ax1,'on');
cycle3(ax1);
hold(ax1,'on');

plot(ax2,ts,ys);
cycle3(ax2);
% grid(ax2,'on');
hold(ax2,'on');
end

%
hold(ax1,'off');
hold(ax2,'off');

xlabel(ax1,'Normalized time $t$ (in seconds)','Interpreter','latex')
% ylabel(ax1,'Amplitude')
ylim(ax1,[-0.1 1.15])
xlim(ax1,[0 max(ti)]);

xlabel(ax2,'Normalized time $t$ (in seconds)','Interpreter','latex')
% ylabel(ax2,'Amplitude')
ylim(ax2,[-0.05 1.1])
xlim(ax2,[0 max(ts)]);


% bode(F)
% hold on;
