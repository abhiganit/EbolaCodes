N0 = 4.09e6;  
KikwitGeneralPrev = 0.81*6.4e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
KikwitNonhospPrev = 5.6e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
Sw0 = (2.8/10000)*N0;
alpha = 9.5;        % 1/alpha: mean duration of the incubation period 
gammaD = 7.9;       % 1/gammaD: mean duration from onset to death
gammaI = 9; %10;      % 1/gammaI: mean duration of the infectious period for survivors
gammaH = 4.9;    % 1/Time between hospitalization and death
fGHN = 62131;
fHG = 7;          % 1/average time spent at in hospital with non-ebola disease
M =  5;            % average family size
% MH = 1;             % additional family members visiting hospital
omega = ((21*1.2-19)/2)*(KikwitNonhospPrev/KikwitGeneralPrev);
delta = 0.72;       % percentage Symptomatic illness 


y = [Sw0,alpha,gammaD,gammaI,gammaH,fGHN,fHG,M,omega,delta]; % Parameters
x0 = EbolaModelFit(y);
[RelIncd0,HcwRatio0] = EbolaModelRunVaccTx_delayDec(x0,y)



for i = 1:length(y);
    old = y(i);
    y(i) = y(i)+0.01*y(i);
    x = EbolaModelFit(y);
    [RelIncd1,HcwRatio1] = EbolaModelRunVaccTx_delayDec(x,y);
    sensitivityCI(i) = (RelIncd1-RelIncd0)/(0.01*y(i));
    sensitivityHR(i) = (HcwRatio1-HcwRatio0)/(0.01*y(i));
    elasticityCI(i) = sensitivityCI(i)*old/RelIncd0;
    elasticityHR(i) = sensitivityHR(i)*old/HcwRatio0;
    y(i) = old;
end
    
% % Figures
names = {'$S_{W}(0)$';'$1/\alpha$';'$1/{\gamma_{DG}}$';'$1/{\gamma_{RG}}$';'$1/{\gamma_H}$';'$h$';'$1/f_{HG}$';'$M_F$';'$\omega$';'$\delta$'};
titlenames = {'a) Relative Incidence';
               'b) Maximum Ebola patients per HCW '}
               
               
%Textnames = {'Sensitivities';'Elasticities'};
SI = sensitivityCI;
EI = elasticityCI;
SH = sensitivityHR;
EH = elasticityHR;

NSI = names;
NEI = names;
NSH = names;
NEH = names;
[~, siI] = sort(abs(SI),'ascend');
[~, eiI] = sort(abs(EI),'ascend');
[~, siH] = sort(abs(SH),'ascend');
[~, eiH] = sort(abs(EH),'ascend');
SIsorted = SI(siI);
EIsorted = EI(eiI);
SHsorted = SH(siH);
EHsorted = EH(eiH);
NSIsorted = NSI(siI);
NEIsorted = NEI(eiI);
NSHsorted = NSH(siH);
NEHsorted = NEH(eiH);
Sens_Elas = horzcat(SIsorted',SHsorted',EIsorted',EHsorted');
Names = horzcat(NSIsorted,NSHsorted,NEIsorted,NEHsorted);
fig = figure(1);
set(fig, 'Units','Normalized','Position', [-1, 1, 1 1])
for i = 1:4
    subplot(2,2,i)
    bar1 = barh(Sens_Elas(:,i),'FaceColor',[0.8 0.8 0.8],'LineStyle','None');
    baseline_handle = get(bar1,'BaseLine');
    set(baseline_handle,'LineStyle','--','Color','black')
    box('off')
    xmin = min(Sens_Elas(:,i));
    xmax = max(Sens_Elas(:,i));
    xlim([xmin+0.06*xmin,xmax+0.02*xmax])
    ylim([0,11]);
   [hx,hy] = format_ticks(gca,[],Names(:,i),[],[],[],[],[],'FontSize',14,'FontName','Palatino');
   if i == 1; 
       yls = ylabel('Sensitivities','FontSize',18,'FontName', 'Palatino'); 
       set(yls,'Units','Normalized','Position',[-0.2,0.5]); % get(yls,'position')-[1,0,0]); 
       title('a) Relative Incidence','FontSize',18,'FontName', 'Palatino')
   elseif i ==2;
       title('b) Maximum Ebola patients per HCW','FontSize',18,'FontName', 'Palatino');
   elseif i == 3;
        yle = ylabel('Elasticities','FontSize',18,'FontName', 'Palatino'); 
        set(yle,'Units','Normalized','Position',[-0.2,0.5]);
    end
end





    

