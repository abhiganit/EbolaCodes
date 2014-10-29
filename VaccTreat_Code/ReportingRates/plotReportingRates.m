function plotReportingRates(RRindex, Delayindex)
%close all
xaxis = 0.1:0.1:1.0;
delays = [182, 244];
color = ['b','r','g','m','c'];

%close all
if Delayindex==1 && RRindex == 1
    close all
    fig = figure;
set(fig, 'Position', [100 100 1600 900]);
xlimits = [0.07,1.03];
% set(gcf,'position',...
%          get(0,'screensize'));
ss = get(0,'screensize');
set(gcf,'position',...
         [100, 100, ss(3)/1.5, ss(4)]);
else
   figure(gcf); 
   
end
plotwidth = 0.41;
plotheight = 0.19;
leftmargin = 0.1;
%rightmargin = 0.05;
bottommargin = 0.05;
columnspace = 0.03;
rowspace = 0.05;
%midspace = 0.09;

labelsize = 18;
ticksize = 18;
titlesize = 20;
legendsize = 15;

xlimits = [0.09,1.01];

if RRindex==1 && Delayindex==1
    %first column
    ax(1) = axes('Position',  [leftmargin,                           bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight], 'Tag','1');
    ax(3) = axes('Position',  [leftmargin,                           bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight], 'Tag','3');
    ax(5) = axes('Position',  [leftmargin,                           bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight], 'Tag','5');
    ax(7) = axes('Position',  [leftmargin,                           bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight], 'Tag','7');
    %second column
    ax(2) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight], 'Tag','2');
    ax(4) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight], 'Tag','4');
    ax(6) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight], 'Tag','6');
    ax(8) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight], 'Tag','8');
% elseif RRindex==1 && Delayindex==2
%     
%     %ax(3) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight]); 
else
    ax = findall(gcf,'type','axes');
end
%ax(6) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]); 

%middle row


%ax(9) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]); 

%bottom row


%ax(12) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);




filename = sprintf('TreatmentDetResults_reportingrates');
load(filename);
index = 1;

    
    % means of no interventions
    nointerventioncases = cumulativecasesTX_ni(end); %at the end of year
    nointerventiondeaths =  cumulativedeathsTX_ni(end); %at the end of year
    nointerventionmaxhcwratio = max((currentebolahospitalizationsTX_ni./currenthcwTX_ni)')'; 

    interventioncases = cell2mat( cellfun( @(a) a(end), cumulativecasesTX{index}, 'UniformOutput', false));
    interventiondeaths =  cell2mat(cellfun( @(a) a(end), cumulativedeathsTX{index}, 'UniformOutput', false));
    interventiontxdoses =  cell2mat(cellfun( @(a) a(end), totaltreatmentdosesTX{index}, 'UniformOutput', false));
    interventionmaxhcwratio =  cell2mat(cellfun( @(a,b) max((a./b)')', currentebolahospitalizationsTX{index}, currenthcwTX{index}, 'UniformOutput', false));
    relativeIncidence =  interventioncases./ repmat(nointerventioncases, size(interventioncases,1), size(interventioncases,2));
    relativeDeaths =  interventiondeaths./ repmat(nointerventiondeaths, size(interventiondeaths,1), size(interventiondeaths,2));
    livesSaved =  repmat(nointerventiondeaths, size(interventiondeaths,1), size(interventiondeaths,2)) - interventiondeaths;
    


    %% 1st ROW
    myax = findAxesTag(0*2, Delayindex); 
    %axes(ax(0*2 + Delayindex));
    axes(myax)
    set(gca, 'XLim', xlimits, 'YLim', [0 1.01], 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
    hold on;

        plot(xaxis, relativeIncidence, 'o', 'MarkerFaceColor', color(RRindex), 'Color', color(RRindex))
    if Delayindex==1 
        text(-0.05,0.5, {'Relative', 'incidence'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
        leg = legend('0%', '20%', '40%', '60%');
        set(leg, 'FontSize', legendsize, 'FontName', 'Palatino')
        v = get(leg,'title');
        set(v,'string','Under-reporting', 'FontName', 'Palatino', 'FontSize', legendsize);
        set(leg, 'EdgeColor', 'white')
    end
    
    switch Delayindex
        case 1
            title('Treatment begins December 1', 'FontSize', titlesize, 'FontName', 'Palatino')
        case 2
            title('Treatment begins February 1', 'FontSize', titlesize, 'FontName', 'Palatino')
        case 3
            title('6 Month delay', 'FontSize', titlesize, 'FontName', 'Palatino')
    end
    
    
    %% 2nd ROW
    myax = findAxesTag(1*2, Delayindex); 
    axes(myax)
    %axes(ax(1*2 + Delayindex));
    xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
   
    set(gca, 'XLim', xlimits, 'YLim', [0 1.01], 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    hold on;

        plot(xaxis, relativeDeaths, 'o', 'MarkerFaceColor', color(RRindex), 'Color', color(RRindex))

    if Delayindex==1 
        text(-0.05,0.5, {'Relative', 'mortality'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
    end
    
    %% 3rd ROW
    myax = findAxesTag(2*2, Delayindex); 
    axes(myax)
    %axes(ax(2*2 + Delayindex));
    xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
    set(gca, 'XLim', xlimits, 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    hold on;
        plot(xaxis, interventiontxdoses,'o', 'MarkerFaceColor', color(RRindex), 'Color', color(RRindex))
        ylim([0 10e5])
    if Delayindex==1 
        text(-0.05,10e5/2, {'Treatment', 'doses'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
    end
    
    %% 4th ROW
    myax = findAxesTag(3*2, Delayindex); 
    axes(myax)
    %axes(ax(3*2 + Delayindex));
    
    xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
   
    set(gca, 'XLim', xlimits, 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
     hold on;
    ylim([0 1500])
        plot(xaxis, interventionmaxhcwratio, 'o', 'MarkerFaceColor', color(RRindex), 'Color', color(RRindex))

    if Delayindex==1 
        text(-0.05,1500/2, {'Maximum Ebola', 'patients per HCW'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
    end

    end


function out = calculateLOWCI(a)
    B = sort(a);
    out =  B(ceil(0.10*size(a,1)));
end

function out = calculateMEDCI(a)
    B = sort(a);
    out =  B(ceil(0.50*size(a,1)));
end


function out = calculateHIGHCI(a)
    B = sort(a);
    out =  B(ceil(0.90*size(a,1)));
end

function handle = findAxesTag(Prefix, DelayIndex)
        tagnumstr = num2str(Prefix + DelayIndex);
        handle = findobj(get(gcf,'Children'),'Tag',tagnumstr);
end
