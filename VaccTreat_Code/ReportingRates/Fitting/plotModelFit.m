function plotModelFit(estimatedvalues, timepoints, datapoints, maxtime, initial,HospitalVisitors, MaxIt)
close all;
fig = figure;
set(fig, 'Position', [500, 100, 900, 500])

fittingplusvalidationtime = 110;
onetimeset = {0:fittingplusvalidationtime};
alltimepoints = repmat(onetimeset, size(timepoints,1), 1);

% run output for longer period of time (fitting + validation)
output = EbolaModel(0, estimatedvalues, alltimepoints, fittingplusvalidationtime, initial, HospitalVisitors, MaxIt)';

% validation data
%[validationtimepts, validationdatapts] = ReadDataValidation();

% Shift valudation data to account for delays in reporting
% validationtimepts(:,1) = validationtimepts(:,1) + 0;
% validationtimepts(:,2) = validationtimepts(:,2) + 4;
% validationtimepts(:,3) = validationtimepts(:,3) + 0;
% validationtimepts(:,4) = validationtimepts(:,4) + 6;

fittingoutput = output{1};
strings = {'a) Cumulative non-HCW cases', 'b) Cumulative deaths', 'c) Cumulative HCW cases', 'd) Cumulative hospital admissions'};

ci = cellfun(@getCI, fittingoutput, repmat({MaxIt},1,4), 'UniformOutput', false);

for i = 1:size(fittingoutput,2)
    subplot(ceil(size(fittingoutput,2)/2), 2, i)
    hold on;
    %plot(alltimepoints{i}, fittingoutput{i}, 'Color', [0.8 0.8 0.8], 'LineWidth', 1.6)
       
    fill([alltimepoints{i},fliplr(alltimepoints{i})], [ci{i}(1,:),fliplr(ci{i}(2,:))], [0.8 0.8 0.8], 'EdgeColor', [0.8 0.8 0.8])
    plot(timepoints{i}, datapoints{i}, '.r', 'MarkerSize', 14)
%    plot(validationtimepts(:,i), validationdatapts(:,i), '.b', 'MarkerSize', 14)
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