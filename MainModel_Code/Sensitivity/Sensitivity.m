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


% Control Strategies
Strat1 = [0, 0, 0.9, 0, 0, 0.7];
Strat2 = [0, 0, 0, 0, 0.3, 0.8];
Strat3 = [0.8, 0, 0, 0.5, 0, 0];
strategies = [Strat1;Strat2;Strat3]; % Passing control strategies for


for j = 1:3
    controlparams = strategies(j,:);
    output0 = EbolaModelRunIntervention(x0,y,controlparams)
    for i = 1:length(y)+1;
        if i ==12
            old = x0(i-10);
            x0(i-10) = x0(i-10)+0.01*x0(i-10);
            output1 = EbolaModelRunIntervention(x0,y,controlparams);
            sensitivity(i,j) = (output1-output0)/(0.01*x0(i-10));
            elasticity(i,j) = sensitivity(i,j)*old/output0;
            x0(i-10) = old;
        elseif i ==11
            old = y(i);
            y(i) = y(i)-0.01*y(i);
            x = EbolaModelFit(y);
            output1 = EbolaModelRunIntervention(x,y,controlparams);
            sensitivity(i,j) = (output1-output0)/(0.01*y(i));
            elasticity(i,j) = sensitivity(i,j)*old/output0;
            y(i) = old;
        else
            old = y(i);
            y(i) = y(i)+0.01*y(i);
            x = EbolaModelFit(y);
            output1 = EbolaModelRunIntervention(x,y,controlparams);
            sensitivity(i,j) = (output1-output0)/(0.01*y(i));
            elasticity(i,j) = sensitivity(i,j)*old/output0;
            y(i) = old;
        end
    end
end

% % Figures
names = {'$S_{W}(0)$';'$1/\alpha$';'$1/{\gamma_{DG}}$';'$1/{\gamma_{RG}}$';'$1/{\gamma_H}$';'$h$';'$1/f_{HG}$';'$M_F$';'$M_H$';'$\omega$';'$\epsilon$';'$\beta_W$'};
StratNames = {'Hospital Transmission Reduction (90 %) and Hygienic Burial of Hospital Cases (70 %)';
    'Hygienic Burial of Hospital Cases (70 %) and Community Cases (30 %)';
    'Hospital Cases Isolation (80 %) and Hospital Contacts Follow-up/Isolation (50 %)'};
%Textnames = {'Sensitivities';'Elasticities'};
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
    [~,si] = sort(abs(x),'ascend');
    [~,ei] = sort(abs(y),'ascend');
    Sd(:,i) = x(si);
    NS(:,i) = nx(si);
    Ed(:,i) = y(ei);
    NE(:,i) = ny(ei);
end

fig = figure(1);
set(fig, 'Units','Normalized','Position', [-1, 1, 1 1])
for i = 1:3
    % Sensitivity plots
    subplot(2,3,i)
    bar1 = barh(Sd(:,i),'FaceColor',[0.8 0.8 0.8],'LineStyle','None');
    baseline_handle = get(bar1,'BaseLine');
    set(baseline_handle,'LineStyle','--','Color','black')
    box('off')
    xmin = min(Sd(:,i));
    xmax = max(Sd(:,i));
    xlim([1.15*xmin,1.025*xmax]);
   [hx,hy] = format_ticks(gca,[],NS(:,i),[],[],[],[],[],'FontSize',14,'FontName','Palatino');
   if i == 1; 
       yls = ylabel('Sensitivities','FontSize',14); 
       set(yls,'Units','Normalized','Position',[-0.1,0.5]); % get(yls,'position')-[1,0,0]); 
   end
   % Sensitivity plots
    subplot(2,3,i+3)
    bar1 = barh(Ed(:,i),'FaceColor',[0.8 0.8 0.8],'LineStyle','None');
    baseline_handle = get(bar1,'BaseLine');
    set(baseline_handle,'LineStyle','--','Color','black')
    box('off')
    xmin = min(Ed(:,i));
    xmax = max(Ed(:,i));
    xlim([1.15*xmin,1.025*xmax]);
    [hx,hy] = format_ticks(gca,[],NE(:,i),[],[],[],[],[],'FontSize',14,'FontName','Palatino');   
    if i == 1; 
        yle = ylabel('Elasticities','FontSize',14); 
        set(yle,'Units','Normalized','Position',[-0.1,0.5]);
    end
 end

    
%  Annotations

% Titles
annotation(fig,'textbox',...
    [0.13 0.93 0.22 0.05],...
    'String',{'a) Hospital Transmission Reduction (90 %) and Hygienic Burial of Hospital Cases (70 %)'},...
    'FontSize',16,'LineStyle','none');

annotation(fig,'textbox',...
    [0.41 0.93 0.22 0.05],...
    'String',{'b) Hygienic Burial of Hospital Cases (70 %) and Community Cases (30 %)'},...
    'FontSize',16,'LineStyle','none');

annotation(fig,'textbox',...
    [0.69 0.93 0.22 0.05],...
    'String',{'c) Hospital Cases Isolation (80 %) and Hospital Contacts Follow-up/Isolation (50 %)'},...
    'FontSize',16,'LineStyle','none');

annotation(fig,'textbox',...
    [0.042 0.75 0.06 0.035],...
    'String',{'Sensitivities'},...
    'FontSize',14,...
    'LineStyle','none')

annotation(fig,'textbox',...
    [0.042 0.27 0.06 0.035],...
    'String',{'Elasticities'},...
    'FontSize',14,...
    'LineStyle','none')
    