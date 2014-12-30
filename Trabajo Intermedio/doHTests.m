
% Test sobre el tiempo de cada sujeto
resHTSuj = [];
for i=1:length(s)
    resta = ones(length(s{i}),1) - s{i}(:,2);
    dfr = [];
    dsb = [];
    
    for j=1:length(s{i})
        % Si tenemos un dato acertado y correspondiente a fruta
        if s{i}(j,6) == 1
            dfr = [dfr s{i}(j,3)];
        end
        
        % Si tenemos un dato acertado y correspondiente a subliminal
        if s{i}(j,5) == 1
            dsb = [dsb s{i}(j,3)];
        end
    end
    
    % Como tengo diferente cantidad de datos para cada vector calculo la
    % media del que tiene mas elementos y saco aquellos valores que tienen
    % una mayor diferencia absoluta con la media.
    if length(dfr) ~= length(dsb)
        diff = abs(length(dfr)-length(dsb));
        if length(dfr) > length(dsb)
            adfr = abs(dfr - mean(dfr) * ones(1, length(dfr)));
            [~, ind] = sort(adfr);
            
            to_delete = sort(ind(1:diff), 'descend');
            for z=1:length(to_delete)
                dfr(to_delete(z)) = [];
            end
        else
            adsb = abs(dsb - mean(dsb) * ones(1, length(dsb)));
            [~, ind] = sort(adsb);
            
            to_delete = sort(ind(1:diff), 'descend');
            for z=1:length(to_delete)
                dsb(to_delete(z)) = [];
            end
        end
    end

    % Realizo el test de hipotesis.
    [h,p] = ttest(dfr,dsb);
    resHTSuj = [resHTSuj; [i,h,p]];
end
resHTSuj

% Test sobre el tiempo de cada imagen
tiempoSubl = cell(25, 1);
tiempoFruta = cell(25, 1);
for i=1:length(s)           % Itera sobre los sujetos
    for j=1:length(s{i})    % Itera sobre las imagenes
        % Si tenemos un dato acertado y correspondiente a fruta
        if s{i}(j,6) == 1
            tiempoSubl{j} = [tiempoSubl{j} s{i}(j,3)];
        end
        
        % Si tenemos un dato acertado y correspondiente a subliminal
        if s{i}(j,5) == 1
            tiempoFruta{j} = [tiempoFruta{j} s{i}(j,3)];
        end
    end
end

resHTImg = [];
for i=1:25
    dfr = tiempoSubl{i};
    dsb = tiempoFruta{i};
    % Como tengo diferente cantidad de datos para cada vector calculo la
    % media del que tiene mas elementos y saco aquellos valores que tienen
    % una mayor diferencia absoluta con la media.
    if length(dfr) ~= length(dsb)
        diff = abs(length(dfr)-length(dsb));
        if length(dfr) > length(dsb)
            adfr = abs(dfr - mean(dfr) * ones(1, length(dfr)));
            [~, ind] = sort(adfr);
            
            to_delete = sort(ind(1:diff), 'descend');
            for z=1:length(to_delete)
                dfr(to_delete(z)) = [];
            end
        else
            adsb = abs(dsb - mean(dsb) * ones(1, length(dsb)));
            [~, ind] = sort(adsb);
            
            to_delete = sort(ind(1:diff), 'descend');
            for z=1:length(to_delete)
                dsb(to_delete(z)) = [];
            end
        end
    end

    % Realizo el test de hipotesis.
    [h,p] = ttest(dfr,dsb);
    resHTImg = [resHTImg; [i,h,p]];

end
resHTImg

% Test total

% Calculo means
meanTiempoSubl = [];
meanTiempoFruta = [];
varTiempoSubl = [];
varTiempoFruta = [];
for i=1:25
    meanTiempoSubl = [meanTiempoSubl mean(tiempoSubl{i})];
    meanTiempoFruta = [meanTiempoFruta mean(tiempoFruta{i})];
    varTiempoSubl = [varTiempoSubl var(tiempoSubl{i})];
    varTiempoFruta = [varTiempoFruta var(tiempoFruta{i})];
end

resTot = [];
dfr = [];
dsb = [];
for i=1:length(s)    
    for j=1:length(s{i})
        % Si tenemos un dato acertado y correspondiente a fruta
        if s{i}(j,6) == 1
            dfr = [dfr (s{i}(j,3)-meanTiempoFruta(j))/varTiempoFruta(j)];
        end
        
        % Si tenemos un dato acertado y correspondiente a subliminal
        if s{i}(j,5) == 1
            dsb = [dsb (s{i}(j,3)-meanTiempoSubl(j))/varTiempoSubl(j)];
        end
    end
end

mean(dfr)
mean(dsb)

% Como tengo diferente cantidad de datos para cada vector calculo la
% media del que tiene mas elementos y saco aquellos valores que tienen
% una mayor diferencia absoluta con la media.
if length(dfr) ~= length(dsb)
    diff = abs(length(dfr)-length(dsb));
    if length(dfr) > length(dsb)
        adfr = abs(dfr - mean(dfr) * ones(1, length(dfr)));
        [~, ind] = sort(adfr);

        to_delete = sort(ind(1:diff), 'descend');
        for z=1:length(to_delete)
            dfr(to_delete(z)) = [];
        end
    else
        adsb = abs(dsb - mean(dsb) * ones(1, length(dsb)));
        [~, ind] = sort(adsb);

        to_delete = sort(ind(1:diff), 'descend');
        for z=1:length(to_delete)
            dsb(to_delete(z)) = [];
        end
    end
end

% Realizo el test de hipotesis.
[h,p] = ttest2(dfr,dsb)












