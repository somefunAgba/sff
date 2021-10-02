freqw = 0:0.01*pi/2:50*2*pi;
wc = 2*pi*2.5;
norm_freqw = freqw./wc;

close all;
% Comparison Plot of the Magnitude Response of the UDBF(blue), BWF(red), 
% and BMF(brown) with normalized cut-off frequency for 
% orders $n=1$ to to $n=4$.

N= [1 2 4 16];
val = [1.2 2 2 20];
M = containers.Map(N,val);

% figure init
for n = N
fig(n)=figure('Name',['n-',num2str(n)]); %#ok<SAGROW>
axvec(n) = gca; %#ok<SAGROW>
end

%%

% plot
for n=N

[msq1,m1] = magresp_bwf(norm_freqw,1,n);
[msq2,m2] = magresp_udbmf(norm_freqw,1,n);
[msq3,m3] = magresp_bmf(norm_freqw,1,n);
dB = 20*log10(msq1);
wlog = log10(norm_freqw);

% semilogx(norm_freqw,dB); 
% xlim([0 10*max(wlog)]);

axvec(n).XScale = 'log';
axvec(n).YScale = 'log';
% ax = axvec(n);
hold(axvec(n), 'on');
plot(axvec(n),norm_freqw,m1,'LineWidth',1.25,'DisplayName','bwf'); 
plot(axvec(n),norm_freqw,m2,'LineWidth',1.25,'DisplayName','sff (udbmf5)');
plot(axvec(n),norm_freqw,m3,'LineWidth',1.25,'DisplayName','bmf (udbmf0)');
% grid(axvec(n),'off');

% DRY using map structure
ylim(axvec(n),[0 M(n)]); 

xlim(axvec(n),[0 10*max(wlog)]);
cycle3(axvec(n));
axvec(n).Box = 'on';

% pause(1);
legend(axvec(n),'Location','best','Interpreter','tex','FontName','Consolas','FontSize',9);
xlabel(axvec(n),'Normalized frequency $\omega$ (in radians)','Interpreter','latex')
ylabel(axvec(n),'Log Magnitude (dB)','Interpreter','tex','FontName','Consolas','FontSize',10)
% axis(axvec(n),'equal')

hold(axvec(n), 'off');
end

% clc

%%
[thisfp,thisfn,~]= fileparts(which('magrespcmp_sim.m'));
%
for n = N
gcf = fig(n);
figname = fullfile(thisfp,'imgs', "magcmp"+num2str((n))+'.png');
exportgraphics(gcf, figname,'Resolution',300)
figname = fullfile(thisfp,'imgs',"magcmp"+num2str((n))+'.pdf');
exportgraphics(gcf, figname,'Resolution',300)
end