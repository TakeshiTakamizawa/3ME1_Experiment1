function VarFluid_Log = calc_ReLamTur(VarFluid_Log, CriRe)
% Calculate Laminar flow region and Turbulent region
Laminar_flag = 0; Turbulent_flag = 0;
for i = 1:length(VarFluid_Log.ReStd)
    if VarFluid_Log.ReStd(i) < CriRe % Laminar flow region
        Laminar_flag = Laminar_flag + 1;
        j = Laminar_flag;
        VarFluid_Log.Re_Lam(j,1)          = VarFluid_Log.ReStd(i);
        VarFluid_Log.lambda_Lam(j,1)      = VarFluid_Log.lambdaStd(i);
        VarFluid_Log.RelambdaStd_Lam(j,1) = VarFluid_Log.RelambdaStd(i);
    elseif VarFluid_Log.ReStd(i) >= CriRe % Turbulent region
        Turbulent_flag = Turbulent_flag + 1;
        j = Turbulent_flag;
        VarFluid_Log.Re_Tur(j,1)          = VarFluid_Log.ReStd(i);
        VarFluid_Log.lambda_Tur(j,1)      = VarFluid_Log.lambdaStd(i);
        VarFluid_Log.RelambdaStd_Tur(j,1) = VarFluid_Log.RelambdaStd(i);
    else % transition area
    end
end
end