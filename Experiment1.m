% Observation of flow in a circular pipe and measurement of pipe friction loss coefficient
clc; close all; clear;

%% setting condition
addpath(genpath('ToolboxForSimulator'));
importfolder   = 'ToolboxForSimulator/condition';
importfilename = 'Result_Data.xlsx'; % 条件のファイル
Data           = dataimport(importfolder,importfilename,[]);
SS400_data     = readtable('SS400_data.xlsx');
FC250_data     = readtable('FC250_data.xlsx');
A7075_data     = readtable('A7075_data.xlsx');
ADD_data       = readtable('ADD_data.xlsx');

SS400_Ten = calc_str(SS400_data, Data.Tensile.PreArea.SS400, Data.Tensile.stroke.SS400, Data.Tensile.PreLength.SS400, Data.Tensile.Puy.SS400, Data.Tensile.Ply.SS400, Data.Tensile.MaxStress.SS400, Data.Tensile.Pz.SS400);
FC250_Ten = calc_str(FC250_data, Data.Tensile.PreArea.FC250, Data.Tensile.stroke.FC250, Data.Tensile.PreLength.FC250, Data.Tensile.Puy.FC250, Data.Tensile.Ply.FC250, Data.Tensile.MaxStress.FC250, Data.Tensile.Pz.FC250);
A7075_Ten = calc_str(A7075_data, Data.Tensile.PreArea.A7075, Data.Tensile.stroke.A7075, Data.Tensile.PreLength.A7075, Data.Tensile.Puy.A7075, Data.Tensile.Ply.A7075, Data.Tensile.MaxStress.A7075, Data.Tensile.Pz.A7075);
SS400_ADD = calc_ADDstr(ADD_data, Data.Additional.PreArea.SS400, Data.Additional.PreLength.SS400);



function Materials = calc_str(Materials_data, Prearea, stroke, PreL, Puy, Ply, Pmax, Pz)
    Hori = Materials_data.Var1;
    Vert = Materials_data.Var2;
    Hori_L = stroke/Hori(end);
    for i=1:length(Hori)
    Materials.NominalStrain(i) = Hori(i)*Hori_L/PreL;
    Materials.NominalStress(i) = Vert(i)*15/Prearea*10^3; % [Mpa]
    Materials.TrueStrain(i) = log(1 + Materials.NominalStrain(i));
    Materials.TrueStress(i) = Materials.NominalStress(i)*(1 + Materials.NominalStrain(i));
    end
    Materials.sigmaUY = Puy / Prearea*10^3;
    Materials.sigmaLY = Ply / Prearea*10^3;
    Materials.sigmaUTS = Pmax / Prearea*10^3;
    Materials.sigmaT = Pz / Prearea*10^3;
    Materials.delta = abs(Materials.NominalStrain(end) - 1) *100;
    Materials.phi = abs(max(Materials.NominalStress)/max(Materials.TrueStress) - 1)*100;
    Materials.E = (Materials.NominalStress(14) -Materials.NominalStress(13))/(Materials.NominalStrain(14) - Materials.NominalStrain(13));
end

function Materials = calc_ADDstr(Materials_data, Prearea, PreL)
    Hori = Materials_data.Var1;
    Vert = Materials_data.Var2;
    Hori_L = 0.2;
    for i=1:length(Hori)
    Materials.NominalStrain(i) = Hori(i)*Hori_L/PreL;
    Materials.NominalStress(i) = Vert(i)*15/Prearea*10^3; % [Mpa]
    Materials.TrueStrain(i) = log(1 + Materials.NominalStrain(i));
    Materials.TrueStress(i) = Materials.NominalStress(i)*(1 + Materials.NominalStrain(i));
    end
    Materials.E = (Materials.NominalStress(3) - Materials.NominalStress(2))/(Materials.NominalStrain(3) - Materials.NominalStrain(2));
end

% 課題6
figure
plot(SS400_Ten.NominalStrain, SS400_Ten.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(SS400_Ten.TrueStrain, SS400_Ten.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('SS400');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')

figure
plot(FC250_Ten.NominalStrain, FC250_Ten.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(FC250_Ten.TrueStrain, FC250_Ten.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('FC250');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')

figure
plot(A7075_Ten.NominalStrain, A7075_Ten.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(A7075_Ten.TrueStrain, A7075_Ten.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('A7075');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')

% 課題9
disp('【課題9】')
fprintf('ヤング率は %.2f GPa です.\n', max(SS400_ADD.E)/10^3);

% 課題10
disp('【課題10】')
fprintf('最大荷重時の公称応力は %.2f MPa です.\n', max(SS400_ADD.NominalStress));
fprintf('最大荷重時の真応力は %.2f MPa です.\n', max(SS400_ADD.TrueStress));

% 課題11
figure
plot(SS400_ADD.TrueStrain, SS400_ADD.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('aditional');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('True stress - strain')

% 課題12
figure
plot(SS400_Ten.NominalStrain, SS400_Ten.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(SS400_ADD.NominalStrain, SS400_ADD.NominalStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('aditional Nominal');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('伸び計：使用','伸び計：不使用')

figure
plot(SS400_Ten.TrueStrain, SS400_Ten.TrueStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(SS400_ADD.TrueStrain, SS400_ADD.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('aditional True');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('伸び計：使用','伸び計：不使用')

% 課題13
Materials = calc_Charpy(beta);
function Materials = calc_Charpy(beta)
m = 25.093;
g = 8.91;
r = 0.6513;
alpha_MAX = 146.5;
C = 30;
L = 0.7502;
alpha = 145;
K = m*g*r*(cos(beta) - cos(alpha)) - L;
% rho = K*area;
L_los = m*g*r*(cos(beta) - cos(alpha));
end