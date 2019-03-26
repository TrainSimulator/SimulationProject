function plotHistogram(data)

% ============================================================================
% DESCRIPTION
%
% usage: plotStatistics(data)
%
% Plot statistics of a data vector
%
% ----------------------------------------------------------------------------
% PARAMETERS
%
% data    (vector) data vector
%
% ---------------------------------------------------------------------------
% RETURN VALUES
%
%
% ============================================================================

% Plot the histogram of the maximum queue length
figure;histogram(data, 20);
xlabel('avg waittime');
ylabel('frequency');
set(get(gca,'child'),'FaceColor',[0.4,0.4,0.4]);

% Add mean
ylim=get(gca,'ylim');
l1=line([mean(data) mean(data)], ylim,'Color','r','LineWidth',2.0); % mean
% And percentile
l2=line([prctile(data,5) prctile(data,5)], ylim,'LineStyle','--','Color','r','LineWidth',2.0); %  5 percentile
line([prctile(data,95) prctile(data,95)], ylim,'LineStyle','--','Color','r','LineWidth',2.0); % 95 percentile
% Add worst case
l3=line([max(data) max(data)], ylim,'LineStyle',':','Color','r','LineWidth',2.0); %  5 percentile

% Legend
legend([l1 l2 l3],'mean max-queue-length','5 and 95 percentile','worst case','Location','Best');
