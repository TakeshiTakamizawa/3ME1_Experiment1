% Observation of flow in a circular pipe and measurement of pipe friction loss coefficient
clc; close all; clear;

%% setting condition
addpath(genpath('ToolboxForSimulator'));
ExpeData_Inc   = readtable('ExperimentalData_Increase.xlsx');
ExpeData_Dec   = readtable('ExperimentalData_Decrease.xlsx');
Dyn_Viscosity  = readtable('Dyn_Viscosity.xlsx');

importfolder   = 'ToolboxForSimulator/condition';
importfilename = 'Condition.xlsx'; % 条件のファイル
Data           = dataimport(importfolder,importfilename,[]);
Data.Point0Cor = Data.Condition.Manometer.Upstream - Data.Condition.Manometer.Downstream;
disp('ゼロ点補正値：'); disp(Data.Point0Cor);
CriRe_Inc      = 6045; % Increase Critical Reynolds number
CriRe_Dec      = 6030; % Decrease Critical Reynolds number

%% 2原理
% Calculate Reynolds
VarFluid_LogInc = calc_ReLam(Data, ExpeData_Inc, Dyn_Viscosity, CriRe_Inc); % Increase
VarFluid_Logdec = calc_ReLam(Data, ExpeData_Dec, Dyn_Viscosity, CriRe_Dec); % Decrease

%% 結果を表示・プロット
Fontsize_num = 10.5;
OutputName_Inc = '増加過程'; OutputName_Dec = '減少過程';

% § 5.6
plot_ReFri_Comp(VarFluid_LogInc, VarFluid_Logdec, Fontsize_num, OutputName_Inc, OutputName_Dec)

% § 5.8
plot_ReFri(VarFluid_LogInc, Fontsize_num, OutputName_Inc)
plot_ReFri(VarFluid_Logdec, Fontsize_num, OutputName_Dec)

% § 5.16
max_rel_error_Inc = max(VarFluid_LogInc.RelErr, [], 'omitnan');
mean_rel_error_Inc = mean(VarFluid_LogInc.RelErr, 'omitnan');  % 全体の相対誤差の平均
disp(max_rel_error_Inc)
disp(mean_rel_error_Inc)

% 
% figure;
% plot(VarFluid_LogInc.Vm, VarFluid_LogInc.Re, 'o')