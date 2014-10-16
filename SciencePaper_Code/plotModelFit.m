function plotModelFit(estimatedvalues, timepoints, datapoints, maxtime, initial,HospitalVisitors, MaxIt)
close all;
fig = figure;
set(fig, 'Position', [500, 100, 900, 500])

fittingplusvalidationtime = 104;
onetimeset = {0:fittingplusvalidationtime};
alltimepoints = repmat(onetimeset, size(timepoints,1), 1);

% run output for longer period of time (fitting + validation)
output = EbolaModel(0, estimatedvalues, alltimepoints, fittingplusvalidationtime, initial, HospitalVisitors, MaxIt)';

% validation data
validationdata = ReadDataValidation();


fittingoutput = output{1};
strings = {'a) Cumulative Cases', 'b) Cumulative Deaths', 'c) Cumulative HCW Cases', 'd) Cumulative Hospital Admissions'};

ci = cellfun(@getCI, fittingoutput, repmat({MaxIt},1,4), 'UniformOutput', false);

for i = 1:size(fittingoutput,2)
    subplot(ceil(size(fittingoutput,2)/2), 2, i)
    hold on;
    %plot(alltimepoints{i}, fittingoutput{i}, 'Color', [0.8 0.8 0.8], 'LineWidth', 1.6)
       
    fill([alltimepoints{i},fliplr(alltimepoints{i})], [ci{i}(1,:),fliplr(ci{i}(2,:))], [0.8 0.8 0.8], 'EdgeColor', [0.8 0.8 0.8])
    plot(timepoints{i}, datapoints{i}, '.r', 'MarkerSize', 14)
 %   plot(validationdata(:,1), validationdata(:,i+1), '.b', 'MarkerSize', 14)
    xlabel('Time Since 8th June (days)', 'FontName', 'Palatino', 'FontSize', 14)
    title(strings{i}, 'FontName', 'Palatino', 'FontSize', 16)
    set(gca, 'FontSize', 14)
    %ylim([-1 500])
    xlim([-1 fittingplusvalidationtime+1])
end

end


function CI = getCI(array, maxit)

loCI = max(floor(maxit*0.025),1);
hiCI = max(ceil(maxit*0.975),1);
sortedarray = sort(array,1);

CI = sortedarray([loCI,hiCI],:);

end