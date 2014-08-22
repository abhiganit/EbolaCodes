%%%%%%%%%%%%%% TEST PLOTTING OUTPUT %%%%%%%%%%%


function plotAllInterventions(model_pre, model_post, times)

close all;
subplotorder_plots = [1,7,2,8,3,9];
subplotorder_hists = [4,10,5,11,6,12];


% cumulative incidences
%plotCumulativeIncidence(model_pre, model_post, subplotorder)

% new cases
StrategyEffectiveness(model_post,subplotorder_plots, subplotorder_hists);
end