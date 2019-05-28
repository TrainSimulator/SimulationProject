function plotVars(its, mean, var, red_var)
% plots mean and var. as well as controlled var.

figure;
set(gcf,'units','points','position',[100,100,700,500]);

hold on;
l1 = plot(its, mean, 'k', 'LineWidth', 3.0);
hold on;
l2 = plot(its, mean+sqrt(var), '--k', 'LineWidth', 1.5);
hold on;
plot(its, mean-sqrt(var), '--k', 'LineWidth', 1.5);
hold on;
f1 = fill([its fliplr(its)], [mean-sqrt(var) fliplr(mean+sqrt(var))], 'k');
alpha(f1, 0.2);
hold on;
l3 = plot(its, mean+sqrt(red_var),'--b', 'LineWidth', 1.5);
hold on;
plot(its, mean-sqrt(red_var),'--b', 'LineWidth', 1.5);
f2 = fill([its fliplr(its)], [mean-sqrt(red_var) fliplr(mean+sqrt(red_var))], 'b');
alpha(f2, 0.2);
hold on;
l = legend([l1, l2, l3], 'mean', 'std', 'red. std');
xlim([1, its(end)]);
xlabel("iteration");
ylabel("grand avg. waittimes (min)");

set(f1,'EdgeColor','none');
set(f2,'EdgeColor','none');
set(l,'fontsize',18,'box','off','Location','Best');
set(gca,'fontsize',15,'box','off','TickDir','out','TickLength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','XColor',[.2 .2 .2],'YColor',[.2 .2 .2]);
saveas(gcf, 'var_red.png')

end