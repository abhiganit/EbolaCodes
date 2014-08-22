%%%%%%%%%%%%%% TEST PLOTTING OUTPUT %%%%%%%%%%%


function plotAllInterventions(model_pre, model_post, times)

close all;
%subplotorder_plots = [1,7,2,8,3,9];
% subplotorder_plots = [1,2,3];
% subplotorder_hists = [4,5,6];


% cumulative incidences
%plotCumulativeIncidence(model_pre, model_post, subplotorder)

% new cases
StrategyEffectiveness(model_post);
end