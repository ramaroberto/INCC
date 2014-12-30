
for i=1:length(s)
    [m n] = size(s{i});
    sumaDivision = sum(s{i}(:,2));
    for j=1:m
        sumaTiempo(i) = sum(s{i}(j,2)*s{i}(j,3));
    end
    promedio(i) = sumaTiempo/sumaDivision;
    bar(i, promedio(i));
    hold on
end
