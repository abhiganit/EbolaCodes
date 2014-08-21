%%%%%%%%%%%%%% TEST PLOTTING OUTPUT %%%%%%%%%%%


function plotAllInterventions(model_pre, model_post, times)

close all;
fig = figure;
set(fig, 'Position', [500, 100, 900, 500])
% hold on;

subplotorder = [1,2,6,3,7,11,4,8];

for i = 1:7
    t1 = size(model_pre{i},1);
    t2 = size(model_post{i},1);
    subplot(3,4,subplotorder(i))
   
    % pre-intervention era
    plot(1:t1, model_pre{i});
    hold on;
    plot([t1 t1],[0 max(max(model_post{i}(:,2:end)))],'m--','linewidth',1.4)
    % intervention
    plot(t1:(t1+t2-1), model_post{i}(:,2:end)) %autmomaticlaly plots 5 scales of intevention, only need to plot 4
    xlim([1 t1+t2-1]);


end
hold off;

end