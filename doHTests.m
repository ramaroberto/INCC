
% Test sobre el tiempo de cada sujeto
for i=1:length(s)
    resta = ones(length(s{i}),1) - s{i}(:,2);
    dfr = [];
    dsb = [];
    
    for j=1:length(s{i})
        % Si tenemos un dato acertado y correspondiente a fruta
        if s{i}(j,2)*s{i}(j,6) == 1
            dfr = [dfr s{i}(j,3)];
        end
        
        % Si tenemos un dato acertado y correspondiente a subliminal
        if resta(j)*s{i}(j,5) == 1
            dsb = [dfr s{i}(j,3)];
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
    dfr
    dsb
    h = ttest(dfr,dsb)
        
    
    %promedioFruta = sumaTiempoFruta/sumaDivisionFruta;
    %promedioSubl = sumaTiempoSubl/sumaDivisionSubl;
    
    %bar(i, promedioSubl-promedioFruta)
end

