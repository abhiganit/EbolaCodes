function runReportingRate


    output=cell(4,3);

    for index = 1:4
        % set reporting rate
        switch index
            case 1
                reportingrateCommunity = 1.0;
                reportingrateHospital = 1.0;
            case 2
                reportingrateCommunity = 0.95;
                reportingrateHospital = 0.95;
            case 3
                reportingrateCommunity = 0.9;
                reportingrateHospital = 0.9;
            case 4
                reportingrateCommunity = 0.85;
                reportingrateHospital = 0.85;   
        end


        %fit to data and save output for particular reporting rate
        EbolaModelFit(reportingrateCommunity, reportingrateHospital);

        % run intervention with saved output
        output(index,:) = EbolaModelRunIntervention;
        
    end

    %plotting
    plotReportingRate(output);
end