close all;
rng(1); % default;
% Zero-phase filtering helps preserve features 
% in a filtered time waveform exactly where they occur in the unfiltered signal.
% Use filtfilt to zero-phase filter a synthetic 
% electrocardiogram (ECG) waveform. The function that 
% generates the waveform is at the end of the example. 
% The QRS complex is an important feature in the ECG. 
% Here it begins around time point 160.
%% ecg gen.
rng;
Fs = 1e3;
N = 500;
xn = ecg(N) + 0.2*randn([1 N]);
tn = (0:N-1)/Fs;
ep = numel(xn);
xn = xn(1:ep); tn = tn(1:ep);

% order
pass = 4; 
% caution: the higher it is, the more, the numerical instability
n = 2*pass; N = n+1; % n = 2N, for 2N+1 odd-numbered point

% figure(067)
% plot(tn,xn,'LineWidth',1.5,'Color','#ddc','DisplayName','original'); 
% %
% [ylpf, yhpf, g] = fpbmf_mp(xn,63);
% hold on; plot(tn,ylpf,'LineWidth',1.5,'DisplayName','bmf_mp');
% % hold on; plot(tn,yhpf,'Color','#999','LineWidth',1,'DisplayName','bmf_mp');
% hold off; figure(068)
% stackedplot(g(2:end,:)); grid on;

%% binomial filter prototypes
% name = {'udbmf5', 'udbmf0', 'bwf'};
name = {'sff (udbmf5)', 'bmf (udbmf0)', 'bwf', 'sgolay (lsq3)'};

% - damping
% sff
damper_ud5 = const_udbmf5(n);
% bmf
damper_ud0 = 1;
damper = {damper_ud5, damper_ud0};
% - coefficients
am_udbmf5 = udbmfpoly1d(n,0,1);
am_udbmf0 = udbmfpoly1d(n,0,0);
% butterworth filter prototype
% convert to transfer function form
[z,p,k] = buttap(n);
[num,am_bwf] = zp2tf(z,p,k);
am_bwf = round(am_bwf,2);
% sgolay
am_sgf = sgolay(3,n+1);
% Compute the steady state output
am_sgf = am_sgf((n+1+1)./2,:);
%
am = {am_udbmf5, am_udbmf0, am_bwf, am_sgf};
bm = flip(eye(1,n+1),2);

win0 = tn(101); %tn(1);
wine = tn(251);
%% IIR: recursive
kid = numel(name);
Ts = 1;
zb = cell(1,kid); za = cell(1,kid); xpi = cell(1,kid);
figure(881);
plot(tn,xn,'LineWidth',1.5,'Color','#ddc','DisplayName','original');
hold on;
for i = kid-1:-1:1
    [zb{1,i},za{1,i}] = bi_s2z(bm,am{1,i},Ts,1);
    xpi = filtfilt(zb{1,i},za{1,i},xn);
    plot(tn,xpi,'LineWidth',1.5,'DisplayName',name{1,i});
end
% ax = gca; ax.XScale='log';
hold off;
xlim([win0 wine]);
legend('Location','best','Interpreter','tex','FontName','Consolas','FontSize',9);
xlabel('time','Interpreter','tex','FontName','Consolas','FontSize',10)
ylabel('ecg signal','Interpreter','tex','FontName','Consolas','FontSize',10)

%% - normalization constant
norm_const = [damper{1,1:2}].*(2.^n - 2) + 2;
for i = 3:kid
norm_const(i) = sum(am{1,i});
end

for i = 1:4
    am{1,i} = am{1,i}./norm_const(i);
   % am{1,i} = round(am{1,i}./norm_const(i),2);
end

% FIR: non-recursive
kid = numel(name);
Ts = 1;
xpf = cell(1,kid);
figure(882);
plot(tn,xn,'LineWidth',1.5,'Color','#ddc','DisplayName','original');
hold on;
for i = kid:-1:1
    if i~=kid
        xpf = filtfilt(am{1,i},1,xn);
    else
        xpf = filtfilt(am_sgf,1,xn);
    end
    plot(tn,xpf,'LineWidth',1.5,'DisplayName',name{1,i});
end
hold off;
xlim([win0 wine]);
legend('Location','best','Interpreter','tex','FontName','Consolas','FontSize',9);
xlabel('time','Interpreter','tex','FontName','Consolas','FontSize',10)
ylabel('ecg signal','Interpreter','tex','FontName','Consolas','FontSize',10)
%
tax = gca; axes = get(tax);
cols = cell(numel(axes.Children)-1,1);
for ix = 1:numel(axes.Children)-1
cols{ix} = axes.Children(ix,1).Color;
% cols{numel(axes.Children)-ix} = axes.Children(ix,1).Color;
end

%% Impulse and frequency resp.
M = n/2; % symmetric even number
datpts = (-M:M)';

figure(900)
tl=tiledlayout(2,2,'Padding','compact');
for i = kid:-1:1
yy = am{1,i}';
ax=nexttile;
plot(ax,datpts,yy,'--o','Color',cols{i},'MarkerSize',2,'DisplayName',name{1,i});hold on;
stem(ax,datpts,yy,'Color','#ddd');hold off;
xlabel(ax,'time','Interpreter','tex','FontName','Consolas','FontSize',10')
ylabel(ax,'impulse','Interpreter','tex','FontName','Consolas','FontSize',10)
axy = gca;
lg = legend('Orientation','horizontal','Location','best',...
    'Interpreter','tex','FontName','Consolas','FontSize',9);

lg.String = lg.String(1,1);
end
title(tl,{"impulse response: n = "+num2str(n)+", N = "+ num2str(N)},...
    'Interpreter','tex','FontName','Consolas','FontSize',9);

figure(901)
tl = tiledlayout(1,1);
nexttile;
for i = kid:-1:1
h = abs(fftshift(fft([am{1,i}],1024)));
w = linspace(-1,1,numel(h)); 
% pick only causal frequencies
id = find(w>=0);
w=w(id);h=10*log10(h(id));
plot(w, h,'Color',cols{i},'DisplayName',name{1,i}); hold on;

% ax.XScale ='log';
% ax.YScale ='log';
end
grid on; hold off;
axis normal;
% ylim([-3 1])
% 

legend('Location','best','Interpreter','tex','FontName','Consolas','FontSize',9);
title(tl,{"frequency response: n = "+num2str(n)+", N = "+ num2str(N)},...
    'Interpreter','tex','FontName','Consolas','FontSize',9);
xlabel('normalized frequency','Interpreter','tex','FontName','Consolas','FontSize',9)
ylabel('log magntude (dB)','Interpreter','tex','FontName','Consolas','FontSize',9)

%bm = [1 3 3 1]/6;
%am = [3 0 1 0]/3;
%
%%
% [thisfp,thisfn,~]= fileparts(which('steppulsefir.m'));
% %%
% figname = fullfile(thisfp,'imgs', "ecgfreqr"+num2str(max(n))+'.png');
% exportgraphics(gcf, figname,'Resolution',300)
% figname = fullfile(thisfp,'imgs',"ecgfreqr"+num2str(max(n))+'.pdf');
% exportgraphics(gcf, figname,'Resolution',300)
% %%
% figname = fullfile(thisfp,'imgs', "ecgimpr"+num2str(max(n))+'.png');
% exportgraphics(gcf, figname,'Resolution',300)
% figname = fullfile(thisfp,'imgs',"ecgimpr"+num2str(max(n))+'.pdf');
% exportgraphics(gcf, figname,'Resolution',300)
% %%
% figname = fullfile(thisfp,'imgs', "ecgfir"+num2str(max(n))+'.png');
% exportgraphics(gcf, figname,'Resolution',300)
% figname = fullfile(thisfp,'imgs',"ecgfir"+num2str(max(n))+'.pdf');
% exportgraphics(gcf, figname,'Resolution',300)
% %%
% figname = fullfile(thisfp,'imgs', "ecgiir"+num2str(max(n))+'.png');
% exportgraphics(gcf, figname,'Resolution',300)
% figname = fullfile(thisfp,'imgs',"ecgiir"+num2str(max(n))+'.pdf');
% exportgraphics(gcf, figname,'Resolution',300)