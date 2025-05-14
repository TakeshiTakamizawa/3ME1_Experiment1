function VarFluid_Log = calc_PipeFricLoss(Data, ExpeData, VarFluid_Log)
% Calculate　Pipe friction loss coefficient
D = Data.Condition.Specifications.DiameterOfCircular;
L0 = Data.Condition.Specifications.length0;
L = Data.Condition.Specifications.length;
nu = VarFluid_Log.nu;
Q = ExpeData.FlowRate;
g = 9.81;

for i = 1:length(nu)
delta_h(i,1) = (ExpeData.Upstream(i)*10^-3 - ExpeData.Downstream(i)*10^-3);
lambda(i,1) = delta_h(i)/Q(i)^2 * D/L * 2*g * (pi*D^3 /4)^2;
end
VarFluid_Log.delta_h = delta_h;
VarFluid_Log.lambda = lambda;
end