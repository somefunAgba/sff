%
close all;
figure(200);
%
n = ([1:32,32:2^5:2^16]);
rho = const_udbmf5(n);
%
semilogx(n,rho,'LineWidth',1.5,'Color','#ea5'); grid on; axis padded;
hold on;
semilogx(n,rho,'o','MarkerIndices',([1:4, 8:32:256, 256:256:numel(n)]),...
    'MarkerSize',6,'MarkerFaceColor','#353');
xlabel('$$n$$','FontSize',16,'Interpreter','latex')
ylabel('$$\zeta$$','FontSize',16,'Interpreter','latex')
%
[thisfp,thisfn,~]= fileparts(which('rho_features.m'));
figname = fullfile(thisfp,'imgs', 'rhofeatures.png');
exportgraphics(gcf, figname,'Resolution',300)
figname = fullfile(thisfp,'imgs','rhofeatures.pdf');
exportgraphics(gcf, figname,'Resolution',300)
figname = fullfile(thisfp,'imgs','rhofeatures.eps');
exportgraphics(gcf, figname,'Resolution',300)