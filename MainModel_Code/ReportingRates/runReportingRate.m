function runReportingRate

% set reporting rate
reportingrateCommunity = 1.0;
reportingrateHospital = 1.0;

    %fit to data and save output for particular reporting rate
    EbolaModelFit(reportingrateCommunity, reportingrateHospital);

    % run intervention with saved output
    output = EbolaModelRunIntervention(reportingrateCommunity, reportingrateHospital);
    
    

end