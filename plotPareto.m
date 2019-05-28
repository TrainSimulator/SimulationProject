function plotPareto()
% plots pareto front

% load in saved results
clear all; close all;
load('constrained_opt_20190526.mat')

% ugly hard coded variables (see Opt*.m)
waittime_ubs = 24:-0.5:6;  % constraints (waittime upper bounds)
nconstr = length(waittime_ubs); % constraint levels
nsol = length(it_improve); % number of solutions

figure; hold on;
set(gcf,'units','points','position',[100,100,700,500]);
for i = 1:nsol-1
    clf; hold all;
    for k = 1:nconstr
        p.values(i,k,:) = [pareto(i,k).values(1), pareto(i,k).values(2)];
        %p.params(i,k) = pareto(i,k).params;
    end
    %p.constr(i) = waittime_ubs(pareto(i,1).constr);
    %p.it(i) = pareto(i,1).it;
    plot(p.values(i,:,1), p.values(i,:,2)/1e6, '--k', 'LineWidth', 2)
    scatter(p.values(i,:,1), p.values(i,:,2)/1e6, 100, 'k', 'filled');
end

xlabel("mean waiting time (min)");
ylabel("-profit (million CHF)");

set(gca,'fontsize',15,'box','off','TickDir','out','TickLength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','XColor',[.2 .2 .2],'YColor',[.2 .2 .2]);
saveas(gcf, 'pareto.png')

end