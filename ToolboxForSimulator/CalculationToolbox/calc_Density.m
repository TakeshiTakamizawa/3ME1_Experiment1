function Density = calc_Density(Data, ExpeData)
Temp = ExpeData.WaterTemp; % 実測温度[°C]
rho_0 = Data.Condition.TempDefinition.StandardDensity;   % 基準密度 [kg/m^3] (4°Cの水の密度)
alpha = Data.Condition.TempDefinition.TempCoeff; % 温度係数 [1/°C]
T0_K = Data.Condition.TempDefinition.StandardTemp;
T_K = 273.15 + Temp;
rho = rho_0 * (1 - alpha * (T_K - T0_K));
Density = rho;
% 結果表示
% fprintf('温度 %.1f°C の水の密度は %.2f kg/m³ です。\n', T, rho);
