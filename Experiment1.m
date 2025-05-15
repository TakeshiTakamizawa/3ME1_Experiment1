% Observation of flow in a circular pipe and measurement of pipe friction loss coefficient
clc; close all; clear;

%% setting condition
addpath(genpath('ToolboxForSimulator'));
importfolder   = 'ToolboxForSimulator/condition';
importfilename = 'Result_Data.xlsx'; % 条件のファイル
Data           = dataimport(importfolder,importfilename,[]);
SS400_data  = readtable('SS400_data.xlsx');
FC250_data  = readtable('FC250_data.xlsx');
A7075_data  = readtable('A7075_data.xlsx');
ADD_data  = readtable('ADD_data.xlsx');





figure
plot(SS400_data.Var1,SS400_data.Var2,'Color','red','LineStyle','-','LineWidth',5)
xlabel('strain [-]','FontSize',15); ylabel('stress [Pa]','FontSize',15); title('SS400');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];

figure
plot(FC250_data.Var1,FC250_data.Var2,'Color','red','LineStyle','-','LineWidth',5)
xlabel('strain [-]','FontSize',15); ylabel('stress [Pa]','FontSize',15); title('FC250');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];

figure
plot(A7075_data.Var1,A7075_data.Var2,'Color','red','LineStyle','-','LineWidth',5)
xlabel('strain [-]','FontSize',15); ylabel('stress [Pa]','FontSize',15); title('A7075');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];

figure
plot(ADD_data.Var1,ADD_data.Var2,'Color','red','LineStyle','-','LineWidth',5)
xlabel('strain [-]','FontSize',15); ylabel('stress [Pa]','FontSize',15); title('aditional');
ax = gca; ax.XMinorTick = 'on'; ax.YMinorTick = 'on'; ax.TickLength = [0.04, 0.025];