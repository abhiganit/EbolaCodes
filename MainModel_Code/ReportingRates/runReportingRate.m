function runReportingRate

    tic;
    output=cell(8,3);

    for index = 1:8
        % set reporting rate
        switch index
            case 1
                reportingrateCommunity = 1.0;
                reportingrateHospital = 1.0;
            case 2
                reportingrateCommunity = 0.80;
                reportingrateHospital = 0.80;
            case 3
                reportingrateCommunity = 0.70;
                reportingrateHospital = 0.70;
            case 4
                reportingrateCommunity = 0.60;
                reportingrateHospital = 0.60;
                %% 
            case 5
                reportingrateCommunity = 1.0;
                reportingrateHospital = 1.00;
            case 6
                reportingrateCommunity = 0.80;
                reportingrateHospital = 1.00;
            case 7
                reportingrateCommunity = 0.70;
                reportingrateHospital = 1.00;
            case 8
                reportingrateCommunity = 0.60;
                reportingrateHospital = 1.00; 
        end


        %fit to data and save output for particular reporting rate
        EbolaModelFit(reportingrateCommunity, reportingrateHospital);

        % run intervention with saved output
        output(index,:) = EbolaModelRunIntervention;
        
    end

    %plotting
    plotReportingRate1(output);
    h = toc;
    sprintf('Run time: %f mins', h/60)
end