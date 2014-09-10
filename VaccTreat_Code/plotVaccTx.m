function plotVaccTx


xaxis = 0.1:0.1:1.0;
delays = [7, 30, 91];
colors = {'b','r','g','m','c'};

close all;
fig = figure;
set(fig, 'Position', [100 100 1600 900]);
xlimits = [0.09,1.01];

for index = 1:size(delays,2)
    clear nointerventioncases nointerventiondeaths nointerventionmaxhcwratio ...
           interventioncases interventiondeaths interventiontxdoses interventionmaxhcwratio;
    filename = sprintf('VaccTreatmentStochResults_delay%g', delays(index));
    load(filename);
    
    % means of no interventions
    nointerventioncases = cumulativecasesTX_ni(:,end); %at the end of year
    nointerventiondeaths =  cumulativedeathsTX_ni(:,end); %at the end of year
    nointerventionmaxhcwratio = max((currentebolahospitalizationsTX_ni./currenthcwTX_ni)')'; 

    interventioncases = cellfun( @(a) a(:,end), cumulativecasesTX, 'UniformOutput', false);
    interventiondeaths = cellfun( @(a) a(:,end), cumulativedeathsTX, 'UniformOutput', false);
    interventiontxdoses = cellfun( @(a) a(:,end), totaltreatmentdosesTX, 'UniformOutput', false);
    interventionmaxhcwratio = cellfun( @(a,b) max((a./b)')', currentebolahospitalizationsTX, currenthcwTX, 'UniformOutput', false);
    relativeIncidence = cellfun( @(a,b) a./b,  interventioncases, repmat({nointerventioncases}, size(interventioncases,1), size(interventioncases,2)), 'UniformOutput', false);
    relativeDeaths = cellfun( @(a,b) a./b,  interventiondeaths, repmat({nointerventiondeaths}, size(interventiondeaths,1), size(interventiondeaths,2)), 'UniformOutput', false);
    

    %% find means %%
    relativeIncidence_mean = cell2mat( cellfun( @(a) mean(a), relativeIncidence, 'UniformOutput', false));
    relativeDeaths_mean = cell2mat( cellfun( @(a) mean(a), relativeDeaths, 'UniformOutput', false));
    interventiontxdoses_mean = cell2mat( cellfun( @(a) mean(a), interventiontxdoses, 'UniformOutput', false));
    interventionmaxhcwratio_mean = cell2mat( cellfun( @(a) mean(a), interventionmaxhcwratio, 'UniformOutput', false));
    
    %% find lowCI %%
    relativeIncidence_low = cell2mat( cellfun( @calculateLOWCI, relativeIncidence, 'UniformOutput', false));
    relativeDeaths_low = cell2mat( cellfun( @calculateLOWCI, relativeDeaths, 'UniformOutput', false));
    interventiontxdoses_low = cell2mat( cellfun( @calculateLOWCI, interventiontxdoses, 'UniformOutput', false));
    interventionmaxhcwratio_low = cell2mat( cellfun( @calculateLOWCI, interventionmaxhcwratio, 'UniformOutput', false));
    
    %% find highCI %%
    relativeIncidence_high = cell2mat( cellfun( @calculateHIGHCI, relativeIncidence, 'UniformOutput', false));
    relativeDeaths_high = cell2mat( cellfun( @calculateHIGHCI, relativeDeaths, 'UniformOutput', false));
    interventiontxdoses_high = cell2mat( cellfun( @calculateHIGHCI, interventiontxdoses, 'UniformOutput', false));
    interventionmaxhcwratio_high = cell2mat( cellfun( @calculateHIGHCI, interventionmaxhcwratio, 'UniformOutput', false));
    
    
    %% set up subplots %%
    
    
    
    
    %% 1st ROW
    
    h1 = subplot(4,3,0*size(delays,2) + index);
    set(h1, 'XLim', xlimits, 'Box', 'off')
    
    hold on;
    for i=1:5
        ha = errorbar(xaxis, relativeIncidence_mean(:,i), ...
                relativeIncidence_mean(:,i)-relativeIncidence_low(:,i), relativeIncidence_high(:,i)-relativeIncidence_mean(:,i),...
                'x', 'Color', colors{i});
        hb = get(ha,'children');  
        Xdata = get(hb(2),'Xdata');
        temp = 4:3:length(Xdata);
        temp(3:3:end) = [];
        xleft = temp; xright = temp+1; 
        Xdata(xleft) = 0; %Xdata(xleft) - .1;
        Xdata(xright) = 0; %Xdata(xright) + .1;
        set(hb(2),'Xdata',Xdata)
    end
    

        leg = legend('20%', '40%', '60%', '80%', '100%');
        set(leg, 'FontSize', 14, 'FontName', 'Palatino')
    
    
    %% 2nd ROW
    h2 = subplot(4,3,1*size(delays,2) + index);
    plot(h2, xaxis, relativeDeaths_mean);
    set(h2, 'XLim', xlimits, 'Box', 'off')
    hold on;
    for i=1:5
        ha = errorbar(xaxis, relativeDeaths_mean(:,i), ...
                relativeDeaths_mean(:,i)-relativeDeaths_low(:,i), relativeDeaths_high(:,i)-relativeDeaths_mean(:,i),...
                'Color', colors{i});
        hb = get(ha,'children');  
        Xdata = get(hb(2),'Xdata');
        temp = 4:3:length(Xdata);
        temp(3:3:end) = [];
        xleft = temp; xright = temp+1; 
        Xdata(xleft) = 0; %Xdata(xleft) - .1;
        Xdata(xright) = 0; %Xdata(xright) + .1;
        set(hb(2),'Xdata',Xdata)
    end
    
    
    %% 3rd ROW
    h3 = subplot(4,3,2*size(delays,2) + index);
    set(h3, 'XLim', xlimits, 'Box', 'off')
     hold on;
    for i=1:5
        ha = errorbar(xaxis, interventiontxdoses_mean(:,i), ...
                interventiontxdoses_mean(:,i)-interventiontxdoses_low(:,i), interventiontxdoses_high(:,i)-interventiontxdoses_mean(:,i),...
                'Color', colors{i});
        hb = get(ha,'children');  
        Xdata = get(hb(2),'Xdata');
        temp = 4:3:length(Xdata);
        temp(3:3:end) = [];
        xleft = temp; xright = temp+1; 
        Xdata(xleft) = 0; %Xdata(xleft) - .1;
        Xdata(xright) = 0; %Xdata(xright) + .1;
        set(hb(2),'Xdata',Xdata)
    end
    
    
    %% 4th ROW
    h4 = subplot(4,3,3*size(delays,2) + index);
    plot(h4, xaxis, interventionmaxhcwratio_mean);
    set(h4, 'XLim', xlimits, 'Box', 'off')
     hold on;
    for i=1:5
        ha = errorbar(xaxis, interventionmaxhcwratio_mean(:,i), ...
                interventionmaxhcwratio_mean(:,i)-interventionmaxhcwratio_low(:,i), interventionmaxhcwratio_high(:,i)-interventionmaxhcwratio_mean(:,i),...
                'Color', colors{i});
        hb = get(ha,'children');  
        Xdata = get(hb(2),'Xdata');
        temp = 4:3:length(Xdata);
        temp(3:3:end) = [];
        xleft = temp; xright = temp+1; 
        Xdata(xleft) = 0; %Xdata(xleft) - .1;
        Xdata(xright) = 0; %Xdata(xright) + .1;
        set(hb(2),'Xdata',Xdata)
    end
    set(h3, 'XLim', xlimits, 'Box', 'off')
    
    if index==1
       set( get(h1, 'YLabel'), 'String', 'Relative incidence', 'FontSize', 16, 'FontName', 'Palatino')
       set( get(h2, 'YLabel'), 'String', 'Relative mortality', 'FontSize', 16, 'FontName', 'Palatino')
       set( get(h3, 'YLabel'), 'String', 'Number of Tx doses', 'FontSize', 16, 'FontName', 'Palatino')
       set( get(h4, 'YLabel'), 'String', 'Maximum HCW/Ebola patients', 'FontSize', 16, 'FontName', 'Palatino')
    end

end

end



function out = calculateLOWCI(a)
    B = sort(a);
    out =  B(ceil(0.10*size(a,1)));
end

function out = calculateHIGHCI(a)
    B = sort(a);
    out =  B(ceil(0.90*size(a,1)));
end