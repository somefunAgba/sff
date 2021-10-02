freqw = -10*pi:0.1:10*pi;
fc = pi;
norm_freqw = freqw./fc;
n = 5; % 1,%2 %3 %5
[msq1,m1] = magresp_bwf(norm_freqw,1,n);
[msq2,m2] = magresp_udbmf(norm_freqw,1,n);
[msq3,m3] = magresp_bmf(norm_freqw,1,n);

% close all
figure;
subplot(211);
plot(norm_freqw,msq1,'k'); hold on; 
plot(norm_freqw,msq2,'b-.'); 
plot(norm_freqw,msq3,'r-.'); 
grid on; 
ylim([-.05 1.05]);
xlim([0 5]);

subplot(212);
plot(norm_freqw,m1,'k'); hold on; 
plot(norm_freqw,m2,'b-.'); 
plot(norm_freqw,m3,'r-.'); 
grid on; 
ylim([-.05 1.05]);
xlim([0 5]);