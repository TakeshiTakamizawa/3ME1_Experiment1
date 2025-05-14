function VarFluid_LogInc = calc_ReLam(Data, ExpeData_Inc, Dyn_Viscosity, CriRe)
VarFluid_LogInc = calc_VisCoeff(Data, ExpeData_Inc, Dyn_Viscosity); % Calculate dynamic viscosity coefficient
% VarFluid_LogInc = calc_ReLambdaStd(VarFluid_LogInc);
VarFluid_LogInc = calc_ReLambdaStdRel(VarFluid_LogInc);
VarFluid_LogInc = calc_ReLamTur(VarFluid_LogInc,CriRe);% Calculate Laminar flow region and Turbulent region
end