clc; close all; clear *;

%% Step response comparison
tftime = 1;
dt = 0.001; % selected sampling time as nyquist frequency
t = 0:dt:tftime;
kn = round((tftime-0)/dt) + 1;


%%  Bilinear Transform
xa = 10;
% assert(xa > 2, "xa must be > 2 to prevent distortion.")
scale = 2; % 2 for robustness to noise
Tc = xa*scale*dt;
wn = (2*pi/Tc);
% prewarped cutoff frequency
wcm = (2/dt) * tan( wn*(dt/(2)) );

%% DSS

% number of passes of order 2
p = 4;
% filter: polynomial order
n = 2*p;


% Butterworth filter prototype
% Convert to transfer function form
[z,p,k] = buttap(n);
[num,am_bwf] = zp2tf(z,p,k);
bm = num;%flip(eye(1,n+1),2);

% G = tf(bm,am_bwf);
% figure;step(G);grid

% Five-percent Binomial filter prototype
% Binomial filter prototype
am_udbmf5 = udbmfpoly1d(n,0,1);
am_udbmf0 = udbmfpoly1d(n,0,0);

fkd = ones(1,n+1);
for m = 1:(n+1)
    fkd(1,m) = 1./(wcm^(n-m+1));
end

am = {am_udbmf5, am_udbmf0, am_bwf};
name = {'sff (udbmf5)', 'bmf (udbmf0)', 'bwf'};


ax = gca;

y = zeros(kn,3);
u = zeros(kn,1);
for x = 1:3
    
    amd = am{x}.*fkd;
    bmd = bm.*fkd;
    fs = init_fs(n,0);
    
    for nsq = 1:kn
        % unit-step input
        u(nsq,1) = 0.5;
        if nsq > 200 && nsq <= 500
            u(nsq,1) = 1;
        elseif nsq > 500 && nsq <= 800
            u(nsq,1) = 0.02;
        else
        end
        noise = 0.05; % 0.05, 0.1, 0.2
        u(nsq,1) = u(nsq,1) + (-noise + (2*noise*rand));
        
        seq = nsq-1; % sequence id, zero-based
        fs = step_fs(n,u(nsq,1),amd,bmd,fs,dt,seq);
        y(nsq,x)= fs.yk(1);
    end
end

%%
win0 = t(1);
windt = tftime; %numel(t)-1;
%
nexttile;
plot(t,u,'LineWidth',1.5,'Color','#ddc','DisplayName','original');
hold on;
for i = 3:-1:1
    stairs(t,y(:,i),'LineWidth',1.5,'DisplayName',name{1,i});
%     sound(xpi,Fs); pause(2)
end
% ax = gca; ax.YScale='log';
grid on; hold off;
axis normal;
ylim([-0.4 1.2]);
xlim([win0 win0+windt]);
legend('Location','best','Interpreter','tex','FontName','Consolas','FontSize',9);
xlabel('time (in seconds)','Interpreter','tex','FontName','Consolas','FontSize',10)
ylabel('real-time signal','Interpreter','tex','FontName','Consolas','FontSize',10)
%%
[thisfp,thisfn,~]= fileparts(which('iirfs_cmpsim.m'));
figname = fullfile(thisfp,'imgs', "iircmp"+num2str(max(n))+'.png');
exportgraphics(gcf, figname,'Resolution',300)
figname = fullfile(thisfp,'imgs',"iircmp"+num2str(max(n))+'.pdf');
exportgraphics(gcf, figname,'Resolution',300)
figname = fullfile(thisfp,'imgs',"iircmp"+num2str(max(n))+'.eps');
exportgraphics(gcf, figname,'Resolution',300)
