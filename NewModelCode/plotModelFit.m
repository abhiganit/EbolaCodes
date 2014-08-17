function plotModelFit(estimatedvalues, timepoints, datapoints, maxtime)
close all;
fig = figure;
set(fig, 'Position', [500, 100, 900, 500])

onetimeset = {0:maxtime};
alltimepoints = repmat(onetimeset, size(timepoints,1), 1);

modeloutput = EbolaModel(0, estimatedvalues, alltimepoints, maxtime)';

strings = {'Cumulative Cases', 'Cumulative Deaths', 'Cumulative HCW Cases', 'Cumulative Hospital Admissions',  'Cumulative Hospital Discharges'};

for i = 1:size(modeloutput,1)
    subplot(ceil(size(modeloutput,1)/2), 2, i)
    hold on;
    plot(alltimepoints{i}, modeloutput{i}, 'Color', [0.8 0.8 0.8], 'LineWidth', 1.6)
    plot(timepoints{i}, datapoints{i}, '.r', 'MarkerSize', 14)
    xlabel('Time Since Index Case (days)', 'interpreter', 'latex', 'FontSize', 14)
    title(strings{i}, 'interpreter', 'latex', 'FontSize', 16)
    set(gca, 'FontSize', 14)
    ylim([0 400])
    xlim([0 65])
end

end