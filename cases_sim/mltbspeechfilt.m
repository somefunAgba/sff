% Load a speech signal sampled at 7418Hz. 
% it is a recording of a female voice saying the word "MATLAB®."
close all; clear *;
audio = load('mtlb.mat');
x = audio.mtlb;Fs = audio.Fs;
t = (0:length(x)-1)/Fs;
ep = numel(x);
xn = x(1:ep); tn = t(1:ep);

%% binomial filter prototypes
% name = {'udbmf5', 'udbmf0', 'bwf'};
name = {'sff (udbmf5)', 'bmf (udbmf0)', 'bwf', 'sgolay (lsq3)'};

% even data-point filter polynomial order,n => odd-numbered data points k = n+1
n = 24; q = n+1;
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
am_sgf = sgolay(3,q);
% Compute the steady state output
am_sgf = am_sgf((n+1+1)./2,:);
%
am = {am_udbmf5, am_udbmf0, am_bwf, am_sgf};
bm = flip(eye(1,n+1),2);

win0 = t(1000);
windt = 0.02;
%% IIR: recursive
% sound(xn,Fs);pause(2)

kid = numel(name);
Ts = 1;
zb = cell(1,kid); za = cell(1,kid); xpi = cell(1,kid);

figure(881);
plot(tn,xn,'LineWidth',1.5,'Color','#ddc','DisplayName','original');
legend('Location','best','FontSize',10,'FontWeight','bold','Interpreter','latex');
xlabel('time','FontSize',10,'Interpreter','latex')
ylabel('ecg signal','FontSize',10,'Interpreter','tex')
hold on;
for i = kid-1:-1:1
    [zb{1,i},za{1,i}] = bi_s2z(bm,am{1,i},Ts,1);
    xpi = filtfilt(zb{1,i},za{1,i},xn);
    plot(tn,xpi,'LineWidth',1.5,'DisplayName',name{1,i});
    
%     sound(xpi,Fs);
%     pause(2)
end
xlim([win0 win0+windt]);
% ax = gca; ax.XScale='log';


% - normalization constant
norm_const = [damper{1,1:2}].*(2.^n - 2) + 2;
for i = 3:kid
norm_const(i) = sum(am{1,i});
end

for i = 1:4
    am{1,i} = am{1,i}./norm_const(i);
%     am{1,i} = round(am{1,i}./norm_const(i),2);
end

%% FIR: non-recursive
% sound(xn,Fs); 

kid = numel(name);
Ts = 1;
xpf = cell(1,kid);
figure(882);
plot(tn,xn,'LineWidth',1.5,'Color','#ddc','DisplayName','original');

legend('Location','best','FontSize',10,'FontWeight','bold','Interpreter','latex');
xlabel('time','FontSize',10,'Interpreter','latex')
ylabel('ecg signal','FontSize',10,'Interpreter','tex')
hold on;
for i = kid:-1:1
    if i~=kid
        xpf = filtfilt(am{1,i},1,xn);
    else
        xpf = filtfilt(am_sgf,1,xn);
    end
    plot(tn,xpf,'LineWidth',1.5,'DisplayName',name{1,i});
%     sound(xpf,Fs);
%     pause(2)
end
xlim([win0 win0+windt]);

%% Impulse and frequency resp.
N = n/2; % symmetric even number
datpts = (-N:N)';

figure(900)
legend('Location','best','FontSize',10,'FontWeight','bold','Interpreter','latex');
% nexttile
for i = kid:-1:1
yy = am{1,i}';
% stem(datpts,yy,'Color','#ddd');
hold on;
plot(datpts,yy,'-o','DisplayName',name{1,i});
end
hold off;
title({"impulse response of digital filter h[n] with order n = "+num2str(n);
    "and window size N = "+ num2str(n+1)},'FontSize',10,'Interpreter','latex');

% title(['Impulse response h[n] of Savitzky-Golay filter of order N = ' num2str(N), ' and window size 2N+1 =  ' , num2str(2*N+1)]);

figure(901)
% nexttile;
for i = kid:-1:1
ffy = abs(fftshift(fft([am{1,i}],1024)));
plot(linspace(-1,1,numel(ffy)), ffy,'DisplayName',name{1,i});hold on;
ax = gca; 
% ax.XScale ='log';
% ax.YScale ='log';
end
hold off;
legend('Location','best','FontSize',10,'FontWeight','bold','Interpreter','latex');
title('Frequency response magnitude of h[n]','FontSize',10,'Interpreter','latex');


% % bm = [1 3 3 1]/6;
% % % am = [3 0 1 0]/3;
% 
% I = imread('cameraman.tif');
% imshow(I);