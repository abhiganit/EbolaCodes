%load sixmonthcumsum
N0 = 4.09e6;  
KikwitGeneralPrev = 6.4e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
KikwitNonhospPrev = 5.6e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
Sw0 = (2.8/10000)*N0;
alpha = 8;        % 1/alpha: mean duration of the incubation period 
gammaD = 7.5;       % 1/gammaD: mean duration from onset to death
gammaI = 9; %10;      % 1/gammaI: mean duration of the infectious period for survivors
gammaH = 5;    % 1/Time between hospitalization and death
fGHN = 62131;
fHG = 7;          % 1/average time spent at in hospital with non-ebola disease
M =  5;            % average family size
MH = 1;             % additional family members visiting hospital
omega = ((21*1.2-19)/2)*(KikwitNonhospPrev/KikwitGeneralPrev);
epsilon = 100/100;       % percentage Symptomatic illness 


y = [Sw0,alpha,gammaD,gammaI,gammaH,fGHN,fHG,M,MH,omega,epsilon];
x0 = EbolaModelFit(y);

Strat1 = [0, 0, 0.9, 0, 0, 0.7];
Strat2 = [0, 0, 0, 0, 0.3, 0.8];
Strat3 = [0.8, 0, 0, 0.5, 0, 0];
strategies = [Strat1;Strat2;Strat3];

for j = 1:3
    controlparams = strategies(j,:);
    output0 = EbolaModelRunIntervention(x0,y,controlparams)
    for i = 1:length(y)+2;
        if i > 11
            old = x0(i-11);
            x0(i-11) = x0(i-11)+0.1*x0(i-11);
            output1 = EbolaModelRunIntervention(x0,y,controlparams)
            sensitivity(i,j) = (output1-output0)/(0.1*x0(i-11));
            elasticity(i,j) = sensitivity(i,j)*old/output0;
            x0(i-11) = old;
        elseif i ==11
            old = y(i);
            y(i) = y(i)-0.1*y(i);
            x = EbolaModelFit(y);
            output1 = EbolaModelRunIntervention(x,y,controlparams);
            sensitivity(i,j) = (output1-output0)/(0.1*y(i));
            elasticity(i,j) = sensitivity(i,j)*old/output0;
            y(i) = old;
        else
            old = y(i);
            y(i) = y(i)+0.1*y(i);
            x = EbolaModelFit(y);
            output1 = EbolaModelRunIntervention(x,y,controlparams);
            sensitivity(i,j) = (output1-output0)/(0.1*y(i));
            elasticity(i,j) = sensitivity(i,j)*old/output0;
            y(i) = old;
        end
    end
end

% % Figures
names = {'$S_{W}(0)$';'$1/\alpha$';'$1/{\gamma_{DG}}$';'$1/{\gamma_{RG}}$';'$1/{\gamma_H}$';'$h$';'$1/f_{HG}$';'$M_F$';'$M_H$';'$\omega$';'$\epsilon$'};
S = sensitivity;
E = elasticity;
NS = repmat(names,1,3);
NE = NS;
[~, si] = sort(abs(S),'ascend');
[~, ei] = sort(abs(E),'ascend');



for i = 1:3
    x = S(:,i);
    y = E(:,i);
    nx = NS(:,i);
    ny = NE(:,i);
    [~,si] = sort(abs(x),'ascend')
    [~,ei] = sort(abs(y),'ascend')
    Sd(:,i) = x(si);
    NS(:,i) = nx(si);
    Ed(:,i) = y(ei);
    NE(:,i) = ny(ei);
end

fig = figure;
set(fig, 'Position', [500, 100, 1200, 500])

for i = 1:3
    % Sensitivity plots
    subplot(2,3,i)
    bar1 = barh(Sd(:,i),'FaceColor',[0.8 0.8 0.8],'LineStyle','None');
    baseline_handle = get(bar1,'BaseLine');
    set(baseline_handle,'LineStyle','--','Color','black')
    box('off')
    xmin = min(Sd(:,i));
    xmax = max(Sd(:,i));
    xlim = [xmin,xmax];
    [hx,hy] = format_ticks(gca,[],NS(:,i),[],[],[],[],[],'FontSize',14,'FontName','Palatino');
    % Sensitivity plots
    subplot(2,3,i+3)
    bar1 = barh(Ed(:,i),'FaceColor',[0.8 0.8 0.8],'LineStyle','None');
    baseline_handle = get(bar1,'BaseLine');
    set(baseline_handle,'LineStyle','--','Color','black')
    box('off')
    xmin = min(Ed(:,i));
    xmax = max(Ed(:,i));
    xlim = [xmin,xmax];
    [hx,hy] = format_ticks(gca,[],NE(:,i),[],[],[],[],[],'FontSize',14,'FontName','Palatino');
end

    





% names = {'$S_{W}(0)$';'$1/\alpha$';'$1/{\gamma_{DG}}$';'$1/{\gamma_{RG}}$';'$1/{\gamma_H}$';'$h$';'$1/f_{HG}$';'$M_F$';'$M_H$';'$\omega$';'$\epsilon$'};
% % [u,sensitivity_indices] = sort(abs(sensitivity),'ascend');
% % sensitivity_data  = sensitivity(sensitivity_indices);
% % sensitivity_names = names(sensitivity_indices);
% % [u,elasticity_indices] = sort(abs(elasticity),'ascend');
% % elasticity_data  = elasticity(elasticity_indices);
% % elasticity_names = names(elasticity_indices);
% 
% fig = figure;
% set(fig, 'Position', [500, 100, 1200, 500])
% % Sensitivity plot
% subplot(1,2,1)
% bar1 = barh(sensitivity_data,'FaceColor',[0.8 0.8 0.8],'LineStyle','None');
% baseline_handle = get(bar1,'BaseLine');
% set(baseline_handle,'LineStyle','--','Color','black')
% box('off')
% xmin = min(sensitivity);
% xmax = max(sensitivity);
% xlim = [xmin,xmax];
% [hx,hy] = format_ticks(gca,[],sensitivity_names,[],[],[],[],[],'FontSize',14,'FontName','Palatino');
% title('a) Sensitivity','FontSize',16,'FontName','Palatino')
% 
% 
% % Elasticity plot
% subplot(1,2,2)
% bar2 = barh(elasticity_data,'FaceColor',[0.8 0.8 0.8],'LineStyle','None')
% baseline_handle = get(bar2,'BaseLine');
% set(baseline_handle,'LineStyle','--','Color','black')
% box('off')
% xmin = min(elasticity);
% xmax = max(elasticity);
% xlim = [xmin,xmax];
% % a = get(gca,'XTickLabel');
% % set(gca,'XTickLabel',a,'FontSize',14)
% %set(gca,'YTick',[])
% [hx,hy] = format_ticks(gca,[],elasticity_names,[],[],[],[],[],'FontName','Palatino','FontSize',14);
% %[hx,hy] = format_ticks(gca,[],[],[],[],[],[],[],'FontSize',14)
% title('b) Elasticity','FontSize',16,'FontName','Palatino')





    