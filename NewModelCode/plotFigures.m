function [] = plotFigures(time, Output)
    
    figure; hold on;
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

end