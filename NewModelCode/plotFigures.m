function [] = plotFigures(time, Output, Incidence)
    close all; fig1 = figure; hold on;
    set(fig1, 'Position', [150 150 1600 900]);
    index = 0;
    colorlist = repmat({'g', 'r' , 'k', 'b'}, 1, 7);
    
    for fieldcell = fieldnames(Output)'
        index = index+1;
        subplot(7,4,index);
        field = fieldcell{1};
        plot(time, Output.(field), 'Color', colorlist{index}, 'linewidth',1.5);
        title(field)
        xlabel 'Time (days)';
    end
    
    fig2 = figure; hold on;
    set(fig2, 'Position', [150 150 1600 300]);
    index = 0;
    colorlist = repmat({'g', 'r' , 'k', 'b'}, 1, 7);
    
    for fieldcell = fieldnames(Incidence)'
        index = index+1;
        subplot(1,4,index);
        field = fieldcell{1};
        plot(time(2:end), Incidence.(field), 'Color', colorlist{index}, 'linewidth',1.5);
        title(field)
        xlabel 'Time (days)';
    end
    
    

end