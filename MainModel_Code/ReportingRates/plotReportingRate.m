function plotReportingRate(output)
close all
% parameters
numstrategy = size(output, 2);
monthlytimes = [30, 91, 183];

% plot parameters
fig = figure;
set(gcf,'position',...
         get(0,'screensize'));
c = [0 0 1; 0 0.5 0; 1 0 0; 0 0.75 0.75];
h = rgb2hsv(c);
h2 = h; 
h2(:,2) = 0.6*h2(:,2);
cmap = hsv2rgb(h2);
strtitle = {{'Strategy a:','HCW Transmission Reduction (90%)', 'Hygienic Burial of Hospital Cases (90%)','','a)'},...
            {'Strategy b:','Hygienic Burial of Hospital Deaths (80%)', 'Hygienic Burial of Community Deaths (30%)','','b)'},...
            {'Strategy c:','Hospital Case Isolation (80%)', 'Hospital Contact-tracing and Quarantining (50%)','','c)'}};
strtitle2 = {{'d)'},...
            {'e)'},...
            {'f)'}};
strleg = {'0%', '20%', '30%', '40%'};
colormap(cmap);


plotwidth = 0.25;
plotheight = 0.13;
leftmargin = 0.1;
rightmargin = 0.05;
bottommargin = 0.05;
columnspace = 0.05;
rowspace = 0.05;
midspace = 0.12;

labelsize = 18;
ticksize = 18;
titlesize = 20;
legendsize = 15;

%top row
ax(1) = axes('Position',  [leftmargin,                           bottommargin+3*plotheight+3*rowspace+midspace, plotwidth, plotheight]);
ax(2) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+3*plotheight+3*rowspace+midspace, plotwidth, plotheight]);
ax(3) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+3*plotheight+3*rowspace+midspace, plotwidth, plotheight]); 

%middle row
ax(4) = axes('Position',  [leftmargin,                           bottommargin+2*plotheight+2*rowspace+midspace, plotwidth, plotheight]);
ax(5) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+2*plotheight+2*rowspace+midspace, plotwidth, plotheight]);
ax(6) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+2*plotheight+2*rowspace+midspace, plotwidth, plotheight]); 

ax(7) = axes('Position',  [leftmargin,                           bottommargin+1*plotheight+2*rowspace,         plotwidth, plotheight]);
ax(8) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+1*plotheight+2*rowspace,         plotwidth, plotheight]);
ax(9) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+1*plotheight+2*rowspace,         plotwidth, plotheight]); 

ax(10) = axes('Position',  [leftmargin,                           bottommargin+0*plotheight+1*rowspace,         plotwidth, plotheight]);
ax(11) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+0*plotheight+1*rowspace,         plotwidth, plotheight]);
ax(12) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+0*plotheight+1*rowspace,         plotwidth, plotheight]); 






%tick marks
a = 365/12;
b = 0:12;
tickmarks = a*b;
ticklabels = {'0','1','2','3','4','5','6','7','8','9','10','11','12'};
xlabstr = {'1 mo', '3 mo', '6 mo'};

for i=1:numstrategy
        
        
        matplotA = cell2mat(output(1:4,i)');
        matplotB = cell2mat(output(5:8,i)');
        cmatplotA = cumsum(matplotA);
        cmatplotB = cumsum(matplotB);
        monthsA = cmatplotA(monthlytimes,:);
        monthsB = cmatplotB(monthlytimes,:);
        
        % trajectory A
        axes(ax(i))
        %subplot(4, numstrategy, i)
        plot(matplotA, 'LineWidth', 1.2);
        title(strtitle{i}, 'FontSize', 20, 'FontName', 'Palatino');
        ylim([0 50])
        xlim([0 366])
        box off;
        set(gca, 'FontName', 'Palatino', 'FontSize', 16,...
                'XTick', tickmarks, 'XTickLabel', ticklabels);
        xlabel('Months After Intervention', 'FontSize', 16, 'FontName', 'Palatino')
        leg = legend(strleg, 'FontSize', 14);
        legend('boxoff');
        if i==1
            text(-61,15, {'Daily', 'Ebola Cases'}, ...
                'Rotation', 90, 'FontName', 'Palatino', 'FontSize', labelsize,...
                'HorizontalAlignment', 'Center'); 
        end

        % cumulative
        axes(ax(i+3))
        %subplot(4, numstrategy, i+3)
        bar(monthsA, 'LineStyle', 'none');
        ylim([0 6300])
        box off;
        set(gca, 'FontName', 'Palatino', 'FontSize', 16)
        set(gca,'XTickLabel',xlabstr, 'FontSize', 16)
        if i==1
            text(-0.5, 4500,...
                'Community and Hospital Under-reporting',...
                'HorizontalAlignment', 'Center',...
                'FontName', 'Palatino',...
                'LineStyle', 'none',...
                'FontSize', 22,...
                'Rotation', 90);
            
            text(0,2500, {'Cumulative', 'Ebola Cases'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', labelsize,...
            'HorizontalAlignment', 'Center'); 

        end
        
        % trajectory B
        axes(ax(i+6))
        %subplot(4, numstrategy, i+6)
        plot(matplotB, 'LineWidth', 1.2);
        title(strtitle2{i}, 'FontSize', 20, 'FontName', 'Palatino');
        ylim([0 50])
        xlim([0 366])
        box off;
        set(gca, 'FontName', 'Palatino', 'FontSize', 16,...
                'XTick', tickmarks, 'XTickLabel', ticklabels);
        xlabel('Months After Intervention', 'FontSize', 16, 'FontName', 'Palatino')
        if i==1
            text(-61,15, {'Daily', 'Ebola Cases'}, ...
                'Rotation', 90, 'FontName', 'Palatino', 'FontSize', labelsize,...
                'HorizontalAlignment', 'Center'); 
        end
        
        % cumulative
        axes(ax(i+9))
        %subplot(4, numstrategy, i+9)
        bar(monthsB, 'LineStyle', 'none');
        ylim([0 6300])
        box off;
        set(gca, 'FontName', 'Palatino', 'FontSize', 16)
        set(gca,'XTickLabel',xlabstr, 'FontSize', 16)
        if i==1
            text(-0.5, 7000,...
                'Community Under-reporting Only',...
                'HorizontalAlignment', 'Center',...
                'FontName', 'Palatino',...
                'LineStyle', 'none',...
                'FontSize', 22,...
                'Rotation', 90);
            
            text(0,2500, {'Cumulative', 'Ebola Cases'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', labelsize,...
            'HorizontalAlignment', 'Center'); 
        end
end

end