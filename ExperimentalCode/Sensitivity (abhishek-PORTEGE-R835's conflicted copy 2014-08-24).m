%load sixmonthcumsum
N0 = 4.09e6;  
Sw0 = (2.8/10000)*N0;
alpha = 8;        % 1/alpha: mean duration of the incubation period 
gammaD = 7.5;       % 1/gammaD: mean duration from onset to death
gammaI = 9; %10;      % 1/gammaI: mean duration of the infectious period for survivors
gammaH = 5;    % 1/Time between hospitalization and death
fGHN = 62131;
fHG = 7;          % 1/average time spent at in hospital with non-ebola disease
M =  5;            % average family size
MH = 1;             % additional family members visiting hospital
omega = 1.2;
epsilon = 100/100;       % percentage Symptomatic illness 


y = [Sw0,alpha,gammaD,gammaI,gammaH,fGHN,fHG,M,MH,omega,epsilon];
x = EbolaModelFit(y)
output0 = EbolaModelRunIntervention(x,y)

for i = 1:length(y);
    if i ==11
        old = y(i);
        y(i) = y(i)-0.1*y(i);
        x = EbolaModelFit(y);
        output1 = EbolaModelRunIntervention(x,y);
        sensitivity(i) = (output1-output0)/(0.1*y(i));
        elasticity(i) = sensitivity(i)*old/output0;
        y(i) = old;
    else
        old = y(i);
        y(i) = y(i)+0.1*y(i);
        x = EbolaModelFit(y);
        output1 = EbolaModelRunIntervention(x,y);
        sensitivity(i) = (output1-output0)/(0.1*y(i));
        elasticity(i) = sensitivity(i)*old/output0;
        y(i) = old;
    end
end
    

% % Figures
names = {'$S_{W}(0)$','$\alpha$','$1/{\gamma_D}$','$1/{\gamma_I}$','$1/{\gamma_H}$','$f_{GH}$','$f_{HG}$','$M$','$M_H$','$\omega$','$\epsilon$'};
%{'S_{w}(0)';'\alpha';'1/(\gamma_D)';'1/(\gamma_I)';'1/(\gamma_H)';'f_{GH}';'f_{HG}';'M';'M_H';'\omega';'\epsilon'};
sensitivity_data  = sensitivity(sensitivity_indices);
sensitivity_names = names(sensitivity_indices);
[u,elasticity_indices] = sort(abs(elasticity),'ascend');
% elasticity_data  = elasticity(elasticity_indices);
% elasticity_names = names(elasticity_indices);
elasticity_data  = elasticity(sensitivity_indices);
elasticity_names = names(sensitivity_indices);

fig = figure;
set(fig, 'Position', [500, 100, 900, 500])
% Sensitivity plot
subplot(1,2,1)
bar1 = barh(sensitivity_data,'FaceColor',[0.8 0.8 0.8],'LineStyle','None');
baseline_handle = get(bar1,'BaseLine');
set(baseline_handle,'LineStyle','--','Color','black')
box('off')
xmin = min(sensitivity);
xmax = max(sensitivity);
xlim = [0.975*xmin,1.025*xmax];
[hx,hy] = format_ticks(gca,[],sensitivity_names,[],[],[],[],[],'FontSize',14);
title('(a) Sensitivity','FontSize',16)
% Elasticity plot
subplot(1,2,2)
bar2 = barh(elasticity_data,'FaceColor',[0.8 0.8 0.8],'LineStyle','None')
baseline_handle = get(bar2,'BaseLine');
set(baseline_handle,'LineStyle','--','Color','black')
box('off')
xmin = min(elasticity);
xmax = max(elasticity);
xlim = [0.975*xmin,1.025*xmax];
%[hx,hy] = format_ticks(gca,[],elasticity_names,[],[],[],[],[],'FontSize',14);
title('(b) Elasticity','FontSize',16)





    