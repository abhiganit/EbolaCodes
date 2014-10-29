function runReportingRates


%% do stuff with model fit

RRvals = [1.0, 0.8, 0.6, 0.4];
Delayvals = [182, 244];

delayindex = 0;

rrindex = 0;
for RR = RRvals
    rrindex = rrindex + 1;
    delayindex = 0;
    for Delay = Delayvals
        delayindex = delayindex + 1;
        % fit model and save output
        cd 'Fitting';
        EbolaModelFit(RR)
        cd ..

        % run treatment model with a given RR and delay
        EbolaModelRunTx(RR,Delay)

        % plot results from given RR and Delay
        plotReportingRates(rrindex, delayindex)
    end
end

end