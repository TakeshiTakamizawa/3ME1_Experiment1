function VarFluid = calc_VisCoeff(Data, ExpeData, Dyn_Viscosity)

VarFluid.mu_mPas = calc_DynViscosity(ExpeData, Dyn_Viscosity); % Calculate DynViscosity
mu_Pas           = VarFluid.mu_mPas * 1e-3;   % mPa·s を Pa·s に変換
VarFluid.rho     = calc_Density(Data, ExpeData);
D_mm             = Data.Condition.Specifications.DiameterOfCircular; % [mm]
D_m              = D_mm/10^3;
L0_mm            = Data.Condition.Specifications.length0;
L_mm             = Data.Condition.Specifications.length; % [mm]
L_m              = L_mm/10^3;
Q_Lmin           = ExpeData.FlowRate; % [L/min]
Q_m3sec          = Q_Lmin/(60*10^3);
g                = 9.81;
delta_h0 = Data.Point0Cor;

for i = 1:length(mu_Pas)
    % Calculate dynamic viscosity coefficient
    VarFluid.nu(i,1) = mu_Pas(i) / VarFluid.rho(i);         % 動粘性係数 [m^2/s]
    % Calculate Reynolds
    VarFluid.Vm(i,1) = (4*Q_m3sec(i)/(pi * D_m^2));
    VarFluid.Re(i,1) = (VarFluid.Vm(i) * D_m/VarFluid.nu(i));
    % Calculate Pipe friction loss coefficient
    VarFluid.delta_h(i,1) = ((ExpeData.Upstream(i) - ExpeData.Downstream(i) - delta_h0)*sin(pi/6))/10^3;
    VarFluid.lambda(i,1) = VarFluid.delta_h(i) * D_m/L_m * 2*g / VarFluid.Vm(i)^2;
end

end

