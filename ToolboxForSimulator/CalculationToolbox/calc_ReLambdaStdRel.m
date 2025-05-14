function VarFluid_Log = calc_ReLambdaStdRel(VarFluid_Log)
% データを定義
Re = VarFluid_Log.Re;
lambda = VarFluid_Log.lambda;

% 初期化
result = [];
std_error = [];
rel_error = [];  % 相対誤差（新しく追加）
n = length(Re); % データ数

i = 1;
while i <= n-2
    if Re(i) == Re(i+1) && Re(i) == Re(i+2)
        lambda_group = lambda(i:i+2);
        avg = mean(lambda_group);
        sd = std(lambda_group);
        rel_err = sd / avg;  % 相対誤差（単位なし）

        result = [result; Re(i), avg, sd];
        std_error = [std_error; sd];
        rel_error = [rel_error; rel_err];  % 新しい配列に保存

        i = i + 3;
    else
        result = [result; Re(i), lambda(i), NaN];
        std_error = [std_error; 0];
        rel_error = [rel_error; NaN];  % 相対誤差はNaN
        i = i + 1;
    end
end

if i <= n
    result = [result; Re(i), lambda(i), NaN];
    std_error = [std_error; NaN];
    rel_error = [rel_error; NaN];  % 最後の処理にも追加
end

% 結果の保存
VarFluid_Log.ReStd = result(:,1);
VarFluid_Log.lambdaStd = result(:,2);
VarFluid_Log.RelambdaStd = result(:,3);
VarFluid_Log.RelErr = rel_error;  % ★相対誤差を新しいフィールドに追加
