clear all;
x = 1; 
y = 0.5;
% x = 1: iH,phiC, 2:phiW,phiG,3:pH,pG
% y level of iH, phiW and pH

if x == 1
    
    load('iH_phiC');
    % loads a cell B such B{i} (iH) varies from 0 to 1 which increments at 5 percent
    % so total size is 21. Similarly, each B{i} is a matrix such that (phiC)
    % varies from 0 to 1 which increments at 5 percent.

    iH = y;
    index = floor((iH/0.05)+1);
    time = 1:length(B{index}(:,1));
    time1 = 1:length(B{index}(:,1))-1;
    figure;
    subplot(1,2,1)
    plot(time,B{index});
    str = sprintf('i_H = %0.1f',iH);
    title(str);
    ylabel('Cummulative Cases');
    xlabel('Varying phi_C');
    subplot(1,2,2)
    plot(time1,diff(B{index}));
    title(str);
    ylabel('New Cases');
    xlabel('Varying \phi_C');

elseif x == 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    load('phiW_phiG');
    % loads a cell B such B{i} (iH) varies from 0 to 1 which increments at 5 percent
    % so total size is 21. Similarly, each B{i} is a matrix such that (phiC)
    % varies from 0 to 1 which increments at 5 percent.

    phiW = y;
    index = floor((phiW/0.05)+1);
    time = 1:length(B{index}(:,1));
    time1 = 1:length(B{index}(:,1))-1;
    figure;
    subplot(1,2,1)
    plot(time,B{index});
    str = sprintf('phi_W = %0.1f', phiW);
    title(str);
    ylabel('Cummulative Cases');
    xlabel('Varying \phi_G');
    subplot(1,2,2)
    plot(time1,diff(B{index}));
    title(str);
    ylabel('New Cases');
    xlabel('Varying \phi_G');
else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    load('pH_pG');
    % loads a cell B such B{i} (iH) varies from 0 to 1 which increments at 5 percent
    % so total size is 21. Similarly, each B{i} is a matrix such that (phiC)
    % varies from 0 to 1 which increments at 5 percent.

    pH = y;
    index = floor((pH/0.05)+1);
    time = 1:length(B{index}(:,1));
    time1 = 1:length(B{index}(:,1))-1;
    figure;
    subplot(1,2,1)
    plot(time,B{index});
    str = sprintf('p_H = %0.1f', pH);
    title(str);
    ylabel('Cummulative Cases');
    xlabel('Varying p_G');
    subplot(1,2,2);
    plot(time1,diff(B{index}));
    title(str);
    ylabel('New Cases');
    xlabel('Varying p_G');
end