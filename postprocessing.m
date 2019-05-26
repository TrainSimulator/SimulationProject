% Postprocessing:
clear; close all;
% load('constrained_opt_it_77988.mat')
load('constrained_opt_20190526.mat')

waittime_ubs = 24:-0.5:6;  % constraints (waittime upper bounds)
nconstr = length(waittime_ubs); % Constraint levels
nsol = length(it_improve); % Number of solutions

% vpath = 'C:\Users\alexg\Documents\SimulationOptimization\SimulationProject\figs\pareto_evolution\';
% vid=VideoWriter('test.mp4', 'MPEG-4');
% % vid.FrameRate=10;
% open(vid)
% 
% figure('Position', [1 0 1600 1200]);
% hax = axes;
% for i = 1:nsol-1
%     for k = 1:nconstr
%         p.values(i,k,:) = [pareto(i,k).values(1), pareto(i,k).values(2)];
%         p.params(i,k) = pareto(i,k).params;
%     end
%     p.constr(i) = waittime_ubs(pareto(i,1).constr);
%     p.it(i) = pareto(i,1).it;
%     
%     plot(p.values(i,:,1), p.values(i,:,2),'LineWidth',2)
%     xlim([min(waittime_ubs)-1, max(waittime_ubs)+1]);
%     hold on;
%     if i ~= nsol-1
%         line([p.constr(i) p.constr(i)],get(hax,'YLim'),'Color',[1 0 0],'LineWidth',1)
%     end
%     yl = get(gca,'ylim');
%     xl = get(gca,'xlim');
%     text(xl(1) + 16.5, yl(2) - 0.06*(yl(2)-yl(1)), ['it = ' num2str(p.it(i))])
%     plot([xl(1) xl(2)], [0 0], 'Color', 'black', 'LineWidth', 0.5)
%     xlabel('average waittime [s]');
%     ylabel('profit [CHF]');
%     hold off;
%     set(gcf, 'color', 'white')
%     writeVideo(vid, getframe(gcf));
% %     pause(0.02)
%     
% %     fname = [vpath 'pareto_evolve' num2str(i) '.png'];
% %     export_fig(fname, '-transparent', '-nocrop')
% end
% close(vid)
% return

figure; hold on;
for i = 1:nsol-1
    clf; hold all;
    for k = 1:nconstr
        p.values(i,k,:) = [pareto(i,k).values(1), pareto(i,k).values(2)];
        p.params(i,k) = pareto(i,k).params;
    end
    p.constr(i) = waittime_ubs(pareto(i,1).constr);
    p.it(i) = pareto(i,1).it;
    
    plot(p.values(i,:,1), p.values(i,:,2),'LineWidth',2)
%         plot(pareto(i,k).values(1), pareto(i,k).values(2))
%         pareto(i,k).values(1), pareto(i,k).values(2);
%         scatter(pareto(i,k).values(1), pareto(i,k).values(2));
%     end
%     drawnow
%     pause(0.02)
end

figure; hold on;
for k = 1:nconstr
    bar(clvl(k).value(end,1), clvl(k).params(end).FreqOffPeak);
end
