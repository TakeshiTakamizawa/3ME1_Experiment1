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

SS400 = calc_str(SS400_data, Data.Tensile.PreArea.SS400, Data.Tensile.stroke.SS400, Data.Tensile.PreLength.SS400);
FC250 = calc_str(FC250_data, Data.Tensile.PreArea.FC250, Data.Tensile.stroke.FC250, Data.Tensile.PreLength.FC250);
A7075 = calc_str(A7075_data, Data.Tensile.PreArea.A7075, Data.Tensile.stroke.A7075, Data.Tensile.PreLength.A7075);
SS400_ADD = calc_ADDstr(ADD_data, Data.Additional.PreArea.SS400, Data.Additional.PreLength.SS400);

function Materials = calc_str(Materials_data, Prearea, stroke, PreL)
    Hori = Materials_data.Var1;
    Vert = Materials_data.Var2;
    Hori_L = stroke/Hori(end);
    for i=1:length(Hori)
    Materials.NominalStrain(i) = Hori(i)*Hori_L/PreL;
    Materials.NominalStress(i) = Vert(i)/Prearea*10^3; % [Mpa]
    Materials.TrueStrain(i) = log(1 + Materials.NominalStrain(i));
    Materials.TrueStress(i) = Materials.NominalStress(i)*(1 + Materials.NominalStrain(i));
    end    
end

function Materials = calc_ADDstr(Materials_data, Prearea, PreL)
    Hori = Materials_data.Var1;
    Vert = Materials_data.Var2;
    Hori_L = 0.2;
    for i=1:length(Hori)
    Materials.NominalStrain(i) = Hori(i)*Hori_L/PreL;
    Materials.NominalStress(i) = Vert(i)/Prearea*10^3; % [Mpa]
    Materials.TrueStrain(i) = log(1 + Materials.NominalStrain(i));
    Materials.TrueStress(i) = Materials.NominalStress(i)*(1 + Materials.NominalStrain(i));
    end    
end

figure
plot(SS400.NominalStrain, SS400.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(SS400.TrueStrain, SS400.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('SS400');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')

figure
plot(FC250.NominalStrain, FC250.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(FC250.TrueStrain, FC250.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('FC250');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')

figure
plot(A7075.NominalStrain, A7075.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(A7075.TrueStrain, A7075.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('A7075');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')

figure
plot(SS400_ADD.NominalStrain, SS400_ADD.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(SS400_ADD.TrueStrain, SS400_ADD.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('aditional');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')