function plotReportingRate(output)

% parameters
numstrategy = size(output, 2);
monthlytimes = [30, 91, 183];

% plot parameters
fig = figure;
set(fig, 'Position', [100 100 900 400]);
c = [0 0 1; 0 0.5 0; 1 0 0; 0 0.75 0.75];
h = rgb2hsv(c);
h2 = h; 
h2(:,2) = 0.6*h2(:,2);
cmap = hsv2rgb(h2);

colormap(cmap);
for i=1:numstrategy
        
        
        matplot = cell2mat(output(:,i)');
        cmatplot = cumsum(matplot);
        months = cmatplot(monthlytimes,:);
        
        % trajectory
        subplot(2, numstrategy, i)
        plot(matplot);
        ylim([0 30])
        
        % cumulative
        subplot(2, numstrategy, i+3)
        bar(months);
        ylim([0 3000])
end

end