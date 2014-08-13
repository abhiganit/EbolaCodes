function plotModelFit(estimatedvalues, timepoints, datapoints, maxtime)


onetimeset = {0:(maxtime-1)};
alltimepoints = repmat(onetimeset, size(timepoints,1), 1);

modeloutput = EbolaModel(1, estimatedvalues, alltimepoints, maxtime)';

strings = {'Cumulative Cases', 'Cumulative Deaths'};

for i = 1:size(modeloutput,1)
    subplot(size(modeloutput,1), 1, i)
    hold on;
    
    plot(timepoints{i}, datapoints{i}, '.r', 'MarkerSize', 14)
    plot(alltimepoints{i}, modeloutput{i}, 'Color', [0.8 0.8 0.8], 'LineWidth', 1.6)
    xlabel('Time since 21st March (days)', 'interpreter', 'latex', 'FontSize', 14)
    title(strings{i}, 'interpreter', 'latex', 'FontSize', 16)
    set(gca, 'FontSize', 14)
end

end