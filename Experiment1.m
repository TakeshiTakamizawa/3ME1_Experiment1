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


Ten_SS400 = calc_str(SS400_data, Data.Tensile.PreArea.SS400, Data.Tensile.stroke.SS400, Data.Tensile.PreLength.SS400, Data.Tensile.Puy.SS400, Data.Tensile.Ply.SS400, Data.Tensile.MaxStress.SS400, Data.Tensile.Pz.SS400);
Ten_FC250 = calc_str(FC250_data, Data.Tensile.PreArea.FC250, Data.Tensile.stroke.FC250, Data.Tensile.PreLength.FC250, Data.Tensile.Puy.FC250, Data.Tensile.Ply.FC250, Data.Tensile.MaxStress.FC250, Data.Tensile.Pz.FC250);
Ten_A7075 = calc_str(A7075_data, Data.Tensile.PreArea.A7075, Data.Tensile.stroke.A7075, Data.Tensile.PreLength.A7075, Data.Tensile.Puy.A7075, Data.Tensile.Ply.A7075, Data.Tensile.MaxStress.A7075, Data.Tensile.Pz.A7075);
ADD_SS400 = calc_ADDstr(ADD_data, Data.Additional.PreArea.SS400, Data.Additional.PreLength.SS400);



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
plot(Ten_SS400.NominalStrain, Ten_SS400.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(Ten_SS400.TrueStrain, Ten_SS400.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('SS400');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')

figure
plot(Ten_FC250.NominalStrain, Ten_FC250.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(Ten_FC250.TrueStrain, Ten_FC250.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('FC250');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')

figure
plot(Ten_A7075.NominalStrain, Ten_A7075.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(Ten_A7075.TrueStrain, Ten_A7075.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('A7075');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('Nominal stress - strain', 'True stress - strain')

% 課題9
disp('【課題9】')
fprintf('ヤング率は %.2f GPa です.\n', max(ADD_SS400.E)/10^3);

% 課題10
disp('【課題10】')
fprintf('最大荷重時の公称応力は %.2f MPa です.\n', max(ADD_SS400.NominalStress));
fprintf('最大荷重時の真応力は %.2f MPa です.\n', max(ADD_SS400.TrueStress));

% 課題11
figure
plot(ADD_SS400.TrueStrain, ADD_SS400.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('aditional');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('True stress - strain')

% 課題12
figure
plot(Ten_SS400.NominalStrain, Ten_SS400.NominalStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(ADD_SS400.NominalStrain, ADD_SS400.NominalStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('aditional Nominal');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('伸び計：使用','伸び計：不使用')

figure
plot(Ten_SS400.TrueStrain, Ten_SS400.TrueStress,'Color','red','LineStyle','-','LineWidth',5); hold on
plot(ADD_SS400.TrueStrain, ADD_SS400.TrueStress,'Color','blue','LineStyle','-','LineWidth',5);
xlabel('strain [-]','FontSize',15); ylabel('stress [MPa]','FontSize',15); title('aditional True');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];
legend('伸び計：使用','伸び計：不使用')

% 課題13
Charpy_SS400 = calc_Charpy(Data, Data.Charpy.angle_beta.SS400);
Charpy_FC250 = calc_Charpy(Data, Data.Charpy.angle_beta.FC250);
Charpy_A7075 = calc_Charpy(Data, Data.Charpy.angle_beta.A7075);

disp('【課題13】')
fprintf('SS400のシャルピー吸収エネルギーは %.2f J です.\n', Charpy_SS400.K);
fprintf('FC250のシャルピー吸収エネルギーは %.2f J です.\n', Charpy_FC250.K);
fprintf('A7075のシャルピー吸収エネルギーは %.2f J です.\n', Charpy_A7075.K);

function Materials = calc_Charpy(Data, beta) % β[°]
    m = 25.093; % [kg]
    g = 8.91; % [m/s²]
    r = 0.6513; % [m]
    alpha_MAX = 146.5; % [°]
    C = 30; % [kg]
    L = 0.7502; % [m]
    alpha = 145; % [°]
    Materials.L_los = m*g*r*(cos(Data.Charpy.angle_beta.NO*pi/180) - cos(alpha*pi/180)); % [J]
    Materials.K = m*g*r*(cos(beta*pi/180) - cos(alpha*pi/180)) - Materials.L_los; % [J]
    % rho = K*area;
end


% 課題14
FracCoor_data= readtable('Coordinates_data.xlsx');
disp('【課題14】')
Frac_SS400 = calc_area(FracCoor_data.SS400_x, FracCoor_data.SS400_y, Data.Charpy.PreArea.SS400);
    fprintf('SS400の延性破面率: %.2f ％\n', Frac_SS400.DuctileRate);
    fprintf('SS400の脆性破面率: %.2f ％\n', Frac_SS400.BrittleRate);
Frac_FC250 = calc_area(FracCoor_data.FC250_x, FracCoor_data.FC250_y, Data.Charpy.PreArea.FC250);
    fprintf('FC250の延性破面率: %.2f ％\n', Frac_FC250.DuctileRate);
    fprintf('FC250の脆性破面率: %.2f ％\n', Frac_FC250.BrittleRate);
Frac_A7075 = calc_area(FracCoor_data.A7075_x, FracCoor_data.A7075_y, Data.Charpy.PreArea.A7075);
    fprintf('A7075の延性破面率: %.2f ％\n', Frac_A7075.DuctileRate);
    fprintf('A7075の脆性破面率: %.2f ％\n', Frac_A7075.BrittleRate);
function Materials = calc_area(x, y, A)
    x_ductile = x(1:4,1); y_ductile = y(1:4,1); % 延性破面(脆性破面含む)（点1〜4）
    x_brittle = x(5:8,1); y_brittle = y(5:8,1); % 脆性破面（点5〜8）
    kb = convhull(x_brittle, y_brittle);
    kd = convhull(x_ductile, y_ductile);
    Materials.area_brittle = polyarea(x_brittle(kb), y_brittle(kb));
    Materials.area_ductile = polyarea(x_ductile(kd), y_ductile(kd)) - polyarea(x_brittle(kb), y_brittle(kb));
    % Materials.BrittleRate = Materials.area_brittle/A*100;
    Materials.DuctileRate = Materials.area_ductile/A*100;
    Materials.BrittleRate = 100 - Materials.DuctileRate;
    figure
    plot(x,y,"Color",'red')
end