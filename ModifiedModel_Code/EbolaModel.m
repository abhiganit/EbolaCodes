function modelout = EbolaModel(model, x, timepoints, MaxTime, initial, MaxIt,control)
% model = 0 runs stochastic model where as model = 1 runs the difference
% equation.
 y = control;   
 params = paramvalues(x,y);
    
    if model== 0
        clear output;
        %initialize output
        output = nan(22,MaxTime+1,MaxIt);
        parfor i = 1:MaxIt
            %display(i)
            % The main iteration 
            [T, pop]=Stoch_Iteration([0 MaxTime],initial,params);
            output(:,:,i)=pop';

        end
            %% SAVE OUTPUT
            CumulativeCases = output(19,(timepoints{1}+1),:);
            CumulativeDeaths = output(20,(timepoints{1}+1),:);
            CumulativeHealthworkerIncidence = output(21,timepoints{3}+1,:);
            CumulativeHospitalAdmissions = output(22,timepoints{4}+1,:);
            
            CumulativeCases = reshape(CumulativeCases, MaxTime+1, MaxIt);
            CumulativeDeaths = reshape(CumulativeDeaths, MaxTime+1, MaxIt);
            CumulativeHealthworkerIncidence = reshape(CumulativeHealthworkerIncidence, MaxTime+1, MaxIt);
            CumulativeHospitalAdmissions = reshape(CumulativeHospitalAdmissions, MaxTime+1, MaxIt);
            
    else
            % The main iteration (note as it is difference equation, we
            % only run it once)
            [T, pop]=Diffeqn_Iteration([0 MaxTime],initial,params);
            output=pop';
%             
            %% SAVE OUTPUT
            CumulativeCases = output(19,(timepoints{1}+1));
            CumulativeDeaths = output(20,(timepoints{1}+1));
            CumulativeHealthworkerIncidence = output(21,timepoints{3}+1);
            CumulativeHospitalAdmissions = output(22,timepoints{4}+1);
    end
        
    % get model output ready to passing
    FittingOut{1} = CumulativeCases';
    FittingOut{2} = CumulativeDeaths';
    FittingOut{3} = CumulativeHealthworkerIncidence';
    FittingOut{4} = CumulativeHospitalAdmissions';
    %modelout{5} = CumulativeHospitalDischarges;
    
    modelout{1} = FittingOut;
    modelout{2} = output;

end
