function VarFluid_Log = calc_ReLambdaStd(VarFluid_Log)
% データを定義
Re = VarFluid_Log.Re;
lambda = VarFluid_Log.lambda;

% 初期化
result = [];
std_error = [];  % エラーバー用に空の配列を準備
n = length(Re); % データ数

% 3回連続しているデータの処理
i = 1;
while i <= n-2
    if Re(i) == Re(i+1) && Re(i) == Re(i+2)
        % 3連続で同じFlowRateを発見！
        lambda_group = lambda(i:i+2);
        avg = mean(lambda_group);
        sd = std(lambda_group);
        
        % 結果保存
        result = [result; Re(i), avg, sd];
        std_error = [std_error; sd];
        
        % 次は次のデータから探す（重複を防ぐため+3する）
        i = i + 3;
    else
        % 3回連続していない場合、そのままデータを保存
        result = [result; Re(i), lambda(i), NaN];  % Meanはそのままlambdaの値
        std_error = [std_error; 0];  % エラーバーはNaN
        i = i + 1;
    end
end

% まだ残りのデータがあればそのまま保存
if i <= n
    result = [result; Re(i), lambda(i), NaN];
    std_error = [std_error; NaN];
end

VarFluid_Log.ReStd = result(:,1);
VarFluid_Log.lambdaStd = result(:,2);
VarFluid_Log.RelambdaStd = result(:,3);

% % グラフを作成
% figure;
% 
% % loglogを使ってエラーバー付きプロット
% loglog(result(:,1), result(:,2), 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'r');
% hold on;
% 
% % エラーバーの追加
% % ここではy方向のエラーバーstd_errorを使ってエラーバーを描画
% errorbar(result(:,1), result(:,2), std_error, 'o', 'LineWidth', 1.5, 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'r');
% 
% % ラベル付け
% xlabel('Reynolds Number (Re)');
% ylabel('Friction Factor (\lambda)');
% title('loglog: Reynolds Number vs Friction Factor with Error Bars');
% grid on;
