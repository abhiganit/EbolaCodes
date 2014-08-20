%%%%%%%%%%%%%% TEST PLOTTING OUTPUT %%%%%%%%%%%
%close all;
fig = figure;
set(fig, 'Position', [500, 100, 900, 500])

onetimeset = {0:maxtime};
alltimepoints = repmat(onetimeset, size(timesets_total,1), 1);
fittingoutput = model_total;
strings = {'Cumulative Cases', 'Cumulative Deaths', 'Cumulative HCW Cases', 'Cumulative Hospital Admissions',  'Cumulative Hospital Discharges'};

for i = 1:size(fittingoutput,2)
    subplot(ceil(size(fittingoutput,2)/2), 2, i)
    hold on;
    plot(timesets_total{i}, fittingoutput{i}, 'Color', [0.8 0.8 0.8], 'LineWidth', 1.6)
    %plot(timesets{i}, datasets{i}, '.r', 'MarkerSize', 14)
    xlabel('Time Since Index Case (days)', 'interpreter', 'latex', 'FontSize', 14)
    title(strings{i}, 'interpreter', 'latex', 'FontSize', 16)
    set(gca, 'FontSize', 14)
%     ylim([0 400])
%     xlim([0 65])
end