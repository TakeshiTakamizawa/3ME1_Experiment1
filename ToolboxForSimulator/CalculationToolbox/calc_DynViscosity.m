function eta_interp_spline = calc_DynViscosity(ExpeData, Dyn_Viscosity)
Temp = ExpeData.WaterTemp; % 実測温度[°C]
T_data = Dyn_Viscosity.Temperature';  % サンプル温度データ
eta_data = Dyn_Viscosity.Dyn_Viscosity'; % 動的粘度（mPa·s）

% Temp = [19.3, 20];  % 補間したい温度

eta_interp_spline = interp1(T_data, eta_data, Temp, 'spline');  % スプライン補間
