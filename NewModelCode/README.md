EbolaCodes
==========

Matlab codes for stochastic model for Ebola transmission.

Items to think about/include
==========

Monday 11th August: visiting family members who take care of patients in the hospital (feeding, cleaning etc. see Dowell et al. 1999 Kikwit epidemic)

Tuesday 12th August: Reassess the rate at which individuals move to the funeral class (Sf)

Tuesday 12th August: should start with hospitalized people at equilibrium at time=0


Tuesday 12th August: Currently have "case counts" being total people that have ever been infected with EBV regardless whether they are living or dead.  Make sure this is consistent with the data.

Wednesday 13th August: Need to check out Katie's calculation of betaF (betaF = (\omega-1)*betaI*Ig/Ng, where \omega from Roels 1999 study JID).  We need betaF to be constant, therefore required to calculate the prevalence in Kikwit during sampling times of OR calculations.

Wednesday 13th August: Need a vector to include infected immigrant events for every time point

Thursday 14th August: Isolation wards should be included in the model as a fraction of those presentating to hospital. Rate should be fitted to data

Thursday 14th August: Rate of hospitalization should be fitted to data instead of assumed.

Thursday 14th August: We assume that the hospital staff do not move to Hosp class, but remain with same transmission until funeral. But we need to reconsider the movement of these workers to the hospitalized class I think.  In the cumulative hospitalizations I've assumed that all HCW that are sick go to the Ih class.  We should make this symmetric with the rest of the model.


Resolved issues
=========

Tuesday 12th August: still need to output model based on "DaysSince21stMarch" times (resolved 13th Aug)
