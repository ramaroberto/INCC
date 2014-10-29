for i=1:length(resHTSuj)
    hold on
    if ~isnan(resHTSuj(i,3))
        resHTSuj(i,3)
        bar(i, resHTSuj(i,3))
    end
end