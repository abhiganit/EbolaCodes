  load('iH_pHiC_phiG');
    % loads a cell B such B{i} (iH) varies from 0 to 1 which increments at 5 percent
    % so total size is 21. Similarly, each B{i} is a matrix such that (phiC)
    % varies from 0 to 1 which increments at 5 percent.
 
    phiC = 0.5;
    index = floor((phiC/0.05)+1);
    time = 1:length(B{index}(:,1));
    time1 = 1:length(B{index}(:,1))-1;
    figure;
    subplot(1,2,1)
    plot(time,B{index});
    str = sprintf('phi_C = %0.1f', phiC);
    title(str);
    ylabel('Cummulative Cases');
    xlabel('Varying \phi_G');
    subplot(1,2,2)
    plot(time1,diff(B{index}));
    title(str);
    ylabel('New Cases');
    xlabel('Varying \phi_G');
