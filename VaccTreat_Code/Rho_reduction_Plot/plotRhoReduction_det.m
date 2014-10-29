function plotRhoReduction_det()

xaxis = 0.1:0.1:1.0;
delays = [30, 60, 100];
colors = {'b','r','g','m','c'};


fig = figure;
set(fig, 'Position', [100 100 1600 800]);
xlimits = [0.09,1.01];
set(gcf,'position',...
         get(0,'screensize'));
plotwidth = 0.26;
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

%top row
ax(1) = axes('Position',  [leftmargin,                           bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight]);
ax(2) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight]);
ax(3) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight]); 

%middle row
ax(4) = axes('Position',  [leftmargin,                           bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]);
ax(5) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]);
ax(6) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]); 

%middle row
ax(7) = axes('Position',  [leftmargin,                           bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]);
ax(8) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]);
ax(9) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]); 

%bottom row
ax(10) = axes('Position',  [leftmargin,                           bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);
ax(11) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);
ax(12) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);





for index = 1:size(delays,2)
%     clear nointerventioncases nointerventiondeaths nointerventionmaxhcwratio ...
%            interventioncases interventiondeaths interventiontxdoses interventionmaxhcwratio;
    filename = sprintf('VaccTreatmentStochResults_delay183_Det_rho%g', delays(index));
    load(filename);
    
    
     % means of no interventions
    nointerventioncases = cumulativecasesTX_ni(end); %at the end of year
    nointerventiondeaths =  cumulativedeathsTX_ni(end); %at the end of year
    nointerventionmaxhcwratio = max((currentebolahospitalizationsTX_ni./currenthcwTX_ni)')'; 

   

    interventioncases = cell2mat(cellfun( @(a) a(end), cumulativecasesTX, 'UniformOutput', false));
    interventiondeaths = cell2mat(cellfun( @(a) a(end), cumulativedeathsTX, 'UniformOutput', false));
    interventiontxdoses = cell2mat(cellfun( @(a) a(end), totaltreatmentdosesTX, 'UniformOutput', false));
    interventionmaxhcwratio = cell2mat(cellfun( @(a,b) max((a./b)')', currentebolahospitalizationsTX, currenthcwTX, 'UniformOutput', false));
   
    relativeIncidence =  interventioncases./ repmat(nointerventioncases, size(interventioncases,1), size(interventioncases,2));
    relativeDeaths =  interventiondeaths./ repmat(nointerventiondeaths, size(interventiondeaths,1), size(interventiondeaths,2));
    livesSaved =  repmat(nointerventiondeaths, size(interventiondeaths,1), size(interventiondeaths,2)) - interventiondeaths;
    


    
       
     %% 1st ROW
    axes(ax(0*size(delays,2) + index));
    %h1 = subplot(4,3,0*size(delays,2) + index);
    set(gca, 'XLim', xlimits, 'YLim', [0 1], 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
    hold on;
    %for i=1:5
        plot(xaxis, relativeIncidence)
%         ha = errorbar(xaxis, relativeIncidence_mean(:,i), ...
%                 relativeIncidence_mean(:,i)-relativeIncidence_low(:,i), relativeIncidence_high(:,i)-relativeIncidence_mean(:,i),...
%                 'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
%         hb = get(ha,'children');  
%         Xdata = get(hb(2),'Xdata');
%         temp = 4:3:length(Xdata);
%         temp(3:3:end) = [];
%         xleft = temp; xright = temp+1; 
%         Xdata(xleft) = 0; %Xdata(xleft) - .1;
%         Xdata(xright) = 0; %Xdata(xright) + .1;
%         set(hb(2),'Xdata',Xdata)
    %end
    if index==1 
        text(-0.05,0.5, {'Relative', 'incidence'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
        leg = legend('20%', '40%', '60%', '80%', '100%');
        set(leg, 'FontSize', legendsize, 'FontName', 'Palatino')
        v = get(leg,'title');
        set(v,'string','Treatment coverage', 'FontName', 'Palatino', 'FontSize', legendsize);
        set(leg, 'EdgeColor', 'white')
    end
    
    switch index
        case 1
            title('\rho = 30 %', 'FontSize', titlesize, 'FontName', 'Palatino')
        case 2
            title('\rho = 60 %', 'FontSize', titlesize, 'FontName', 'Palatino')
        case 3
            title('\rho = 100 %', 'FontSize', titlesize, 'FontName', 'Palatino')
    end
    
    
    %% 2nd ROW
    axes(ax(1*size(delays,2) + index));
    xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
    %h2 = subplot(4,3,1*size(delays,2) + index);
   % plot(h2, xaxis, relativeDeaths_mean);
    %set(gca, 'XLim', xlimits, 'YLim', [0 1], 'Box', 'off')
    set(gca, 'XLim', xlimits, 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    hold on;
    %for i=1:5
        plot(xaxis, relativeDeaths)
%         ha = errorbar(xaxis, relativeDeaths_mean(:,i), ...
%                 relativeDeaths_mean(:,i)-relativeDeaths_low(:,i), relativeDeaths_high(:,i)-relativeDeaths_mean(:,i),...
%                 'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
%         hb = get(ha,'children');  
%         Xdata = get(hb(2),'Xdata');
%         temp = 4:3:length(Xdata);
%         temp(3:3:end) = [];
%         xleft = temp; xright = temp+1; 
%         Xdata(xleft) = 0; %Xdata(xleft) - .1;
%         Xdata(xright) = 0; %Xdata(xright) + .1;
%         set(hb(2),'Xdata',Xdata)
    %end
    if index==1 
        text(-0.05,0.5, {'Relative', 'mortality'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
    end
    
    %% 3rd ROW
    axes(ax(2*size(delays,2) + index));
    xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
    %h3 = subplot(4,3,2*size(delays,2) + index);
    set(gca, 'XLim', xlimits, 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    hold on;
    %for i=1:5
        plot(xaxis, interventiontxdoses);
%         ha = errorbar(xaxis, interventiontxdoses_mean(:,i), ...
%                 interventiontxdoses_mean(:,i)-interventiontxdoses_low(:,i), interventiontxdoses_high(:,i)-interventiontxdoses_mean(:,i),...
%                'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
%         hb = get(ha,'children');  
%         Xdata = get(hb(2),'Xdata');
%         temp = 4:3:length(Xdata);
%         temp(3:3:end) = [];
%         xleft = temp; xright = temp+1; 
%         Xdata(xleft) = 0; %Xdata(xleft) - .1;
%         Xdata(xright) = 0; %Xdata(xright) + .1;
%         set(hb(2),'Xdata',Xdata)
    %end
    if index==1 
        text(-0.05,1.5e4, {'Treatment', 'doses'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
    end
    
    %% 4th ROW
    axes(ax(3*size(delays,2) + index));
    xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
    %h4 = subplot(4,3,3*size(delays,2) + index);
   % plot(h4, xaxis, interventionmaxhcwratio_mean);
    set(gca, 'XLim', xlimits, 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
     hold on;
     %ylim([0 80])
    %for i=1:5
        plot(xaxis, interventionmaxhcwratio);
%         ha = errorbar(xaxis, interventionmaxhcwratio_mean(:,i), ...
%                 interventionmaxhcwratio_mean(:,i)-interventionmaxhcwratio_low(:,i), interventionmaxhcwratio_high(:,i)-interventionmaxhcwratio_mean(:,i),...
%                 'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
%         hb = get(ha,'children');  
%         Xdata = get(hb(2),'Xdata');
%         temp = 4:3:length(Xdata);
%         temp(3:3:end) = [];
%         xleft = temp; xright = temp+1; 
%         Xdata(xleft) = 0; %Xdata(xleft) - .1;
%         Xdata(xright) = 0; %Xdata(xright) + .1;
%         set(hb(2),'Xdata',Xdata)
    %end
    if index==1 
        text(-0.05,30, {'Maximum Ebola', 'patients per HCW'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
    end
    
%     if index==1
%        set( get(h1, 'YLabel'), 'String', 'Relative incidence', 'FontSize', 16, 'FontName', 'Palatino')
%        set( get(h2, 'YLabel'), 'String', 'Relative mortality', 'FontSize', 16, 'FontName', 'Palatino')
%        set( get(h3, 'YLabel'), 'String', 'Number of Tx doses', 'FontSize', 16, 'FontName', 'Palatino')
%        set( get(h4, 'YLabel'), 'String', 'Maximum Ebola patients/HCW', 'FontSize', 16, 'FontName', 'Palatino')
%     end

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