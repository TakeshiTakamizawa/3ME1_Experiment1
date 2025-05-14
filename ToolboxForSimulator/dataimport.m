function Data = dataimport(folder,filename,Data)
    
    %% dataのインポート
    fileadd = strcat(folder,'/',filename);
    [~,sheets,~] = xlsfinfo(fileadd);
    sheets(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),sheets)) = {''};
    
    for i = 1:length(sheets)
        Data.(char(sheets(i))) = readdata(fileadd,sheets(i)); 
    end

end

function data = readdata(fileadd,sheet)

    [~, ~, raw] = xlsread(fileadd,char(sheet));
    raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
    [~,r] = size(raw);
    
    name = raw(:,1:3:r - 2); cond = raw(:,2:3:r - 1); type = raw(:,3:3:r    );
    [len(1),len(2)] = size(cond);
    
    %% 数値,文字セルを検索
    Rnum = strcmp(type,'double');
    Rstr = strcmp(type,'string');
    
    %% 非数値セルを次の値で置き換え NaN
    numeric          = cond;
    numeric(Rnum==0) = {NaN};
    numeric          = reshape([numeric{:}],size(numeric));
    
    for j = 1:len(2)
        for i = 1:len(1)
            if Rnum(i,j) == 1; data.(char(name(1,j,:))).(char(name(i,j,:))) = numeric(i,j); end
            if Rstr(i,j) == 1; data.(char(name(1,j,:))).(char(name(i,j,:))) = char(cond(i,j)); end            
        end
    end

end
