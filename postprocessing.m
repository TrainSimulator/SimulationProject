% Postprocessing:
clear; close all;
% load('constrained_opt_it_77988.mat')
load('constrained_opt_FINAL.mat')

waittime_ubs = 24:-0.5:6;  % constraints (waittime upper bounds)
nconstr = length(waittime_ubs); % Constraint levels
nsol = length(it_improve); % Number of solutions

for i = 1:nsol-1
    for k = 1:nconstr
        p.values(i,k,:) = [pareto(i,k).values(1), pareto(i,k).values(2)];
        p.params(i,k) = pareto(i,k).params;
    end
    p.constr(i) = waittime_ubs(pareto(i,1).constr);
    p.it(i) = pareto(i,1).it;
end

doVideo = false;
if doVideo
    vpath = 'C:\Users\alexg\Documents\SimulationOptimization\SimulationProject\figs\pareto_evolution\';
    vid=VideoWriter('pareto_evolve.mp4', 'MPEG-4');
    vid.FrameRate=10;
    open(vid)
    
    figure('Position', [1 0 1600 1200]);
    hax = axes;
    for i = 1:nsol-1
        plot(p.values(i,:,1), (-1)*p.values(i,:,2),'LineWidth',2)
        xlim([min(waittime_ubs)-1, max(waittime_ubs)]);
        if p.it(i) > 100
            %             ylim([p.values(i,1,2) p.values(i,end,2)])
            ylim((-1)*[p.values(i,end,2) p.values(i,1,2)])
        end
        hold on;
        if i ~= nsol-1
            line([p.constr(i) p.constr(i)],get(hax,'YLim'),'Color',[1 0 0],'LineWidth',1)
        end
        yl = get(gca,'ylim');
        xl = get(gca,'xlim');
        %         text(xl(1) + 16.5, yl(2) - 0.06*(yl(2)-yl(1)), ['it = ' num2str(p.it(i))])
        text(xl(1) + 16.5, yl(1) + 0.06*(yl(2)-yl(1)), ['it = ' num2str(p.it(i))])
        plot([xl(1) xl(2)], [0 0], 'Color', 'black', 'LineWidth', 0.5)
        xlabel('average waittime [min]');
        ylabel('profit [CHF]');
        hold off;
        ax = gca;
        ax.YDir = 'reverse';
        set(gcf, 'color', 'white')
        writeVideo(vid, getframe(gcf));
        %     pause(0.02)
        
        %     fname = [vpath 'pareto_evolve' num2str(i) '.png'];
        %     export_fig(fname, '-transparent', '-nocrop')
    end
    close(vid)
    return
end

%% Pareto front:
if paretoplot
    figure('Position', [1 0 1000 600]);
    % figure('Position', [1 0 800 800]);
    plot(p.values(end,:,1), (-1)*p.values(end,:,2),'LineWidth',3)
    % xlim([min(waittime_ubs)-1, max(waittime_ubs)]);
    xlim([5.9 21]);
    % ylim([p.values(i,1,2) p.values(i,end,2)])
    ylim((-1)*[p.values(i,end,2) p.values(i,1,2)])
    xlabel('average waittime [min]');
    ylabel('profit [CHF]');
    hold off;
    set(gcf, 'color', 'white')
    ax = gca;
    ax.YDir = 'reverse';
    box on;
    saveas(gcf,'paretofront.png')
end

%% Pareto front specific points:
pointerplot = false;
if pointerplot
    k = [1, 11, 15, 27, 32, 37]; % Selected points
    cases = p.params(end, k);
    save('cases.mat', 'cases')
    
    % Pointer on pareto front:
    figure('Position', [1 0 700 600]);
    hold on;
    k = 32;
    plot(p.values(end,:,1), (-1)*p.values(end,:,2),'LineWidth',3)
    plot(p.values(end,k,1), (-1)*p.values(end,k,2), '.', 'MarkerSize', 40, ...
        'color', 'black')
    plot(p.values(end,k,1), (-1)*p.values(end,k,2), '.', 'MarkerSize', 30, ...
        'color', [0, 0.4470, 0.7410])
    xlim([5.9 21]);
    ylim((-1)*[p.values(i,end,2) p.values(i,1,2)])
    xlabel('average waittime [min]');
    ylabel('profit [CHF]');
    hold off;
    set(gcf, 'color', 'white')
    ax = gca;
    ax.YDir = 'reverse';
    box on;
    saveas(gcf,'paretofront_X.png')
end


%% Pareto solution space:
figure('Position', [1 0 1000 600]); hold on;
h=plot(values_all(:,1), (-1)*values_all(:,2),'.','color',[0.4 0.4 0.4]);
set(h,'markersize',4)
plot(p.values(end,:,1), (-1)*p.values(end,:,2),'LineWidth',3, 'color', [0, 0.4470, 0.7410])
xlabel('average waittime [min]');
ylabel('profit [CHF]');
hold off;
set(gcf, 'color', 'white')
ax = gca;
ax.YDir = 'reverse';
box on;
saveas(gcf,'pareto_space.png')


%% Weights plot:
weightplot = false;
if weightplot
    figure;
    bar(weights_all(end,:)-100,1)
    xlabel('weights')
    ylabel('improvement score')
    saveas(gcf,'weights_all.png')
    
    figure;
    bar(sort(weights_all(end,weights_all(end,:)-100~=0)-100,'descend'),1)
    xlabel('weights')
    ylabel('improvement score')
    saveas(gcf,'weights_sorted.png')
    
    figure;
    bar(weights_all(end,weights_all(end,:)-100~=0)-100,1)
end

%% Bar plots of pareto:
cpeak = [0.8500 0.3250 0.0980]; % Peak color (red/orange)
coffpeak = [0.9290 0.6940 0.1250]; % Off peak color (yellow)
cfreq = [0, 0.4470, 0.7410]; % Frequency color (blue)

paraplot = false;
if paraplot
    %% PEAK
    % 1st class peak
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), p.params(end,k).CarriagesPeak(1), 0.5, 'FaceColor', cpeak)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    ylim([0 3])
    yticks(0:1:3)
    saveas(gcf,'peak_carriage_1st.png')
    
    % 2nd class peak
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), p.params(end,k).CarriagesPeak(2), 0.5, 'FaceColor', cpeak)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    ylim([0 3])
    yticks(0:1:3)
    saveas(gcf,'peak_carriage_2nd.png')
    
    % Frequency peak
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), p.params(end,k).FreqPeak, 0.5, 'FaceColor', cpeak)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    ylim([0 8])
    yticks(0:2:8)
    saveas(gcf,'peak_freq.png')
    
    %% OFF PEAK
    % 1st class peak
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), p.params(end,k).CarriagesOffPeak(1), 0.5, 'FaceColor', coffpeak)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    ylim([0 3])
    yticks(0:1:3)
    saveas(gcf,'offpeak_carriage_1st.png')
    
    % 2nd class peak
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), p.params(end,k).CarriagesOffPeak(2), 0.5, 'FaceColor', coffpeak)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    ylim([0 3])
    yticks(0:1:3)
    saveas(gcf,'offpeak_carriage_2nd.png')
    
    % Frequency peak
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), p.params(end,k).FreqOffPeak, 0.5, 'FaceColor', coffpeak)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    ylim([0 8])
    yticks(0:2:8)
    saveas(gcf,'offpeak_freq.png')
    
    %% SHIFTS
    % Start peak shift:
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), p.params(end,k).ShiftPeakStart, 0.5, 'FaceColor', cfreq)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    saveas(gcf,'shift_pstart.png')
    
    % End peak shift:
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), p.params(end,k).ShiftPeakEnd, 0.5, 'FaceColor', cfreq)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    saveas(gcf,'shift_pend.png')
    
    % Peak duration:
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), p.params(end,k).ShiftPeakStart-p.params(end,k).ShiftPeakEnd, 0.5, 'FaceColor', cfreq)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    ax = gca;
    ax.YDir = 'reverse';
    saveas(gcf,'peak_duration.png')
    
    % Peak shift:
    figure('Position', [1 0 200 200]); hold on
    for k = 7:nconstr
        bar(waittime_ubs(k), (p.params(end,k).ShiftPeakStart+p.params(end,k).ShiftPeakEnd)/2, 0.5, 'FaceColor', cfreq)
    end
    xlim([5.75 21.25])
    xticks(6:5:21)
    ax = gca;
    ax.YDir = 'reverse';
    saveas(gcf,'peak_shift.png')
end

