sumaTiempo = zeros(25,1);
cuentaIncorrectas = zeros(25,1);
for i=1:length(s)
    resta = ones(length(s{i}),1) - s{i}(:,2);
    for j=1:length(s{i})
        indice = s{i}(j,1) - 1;
        sumaTiempo(indice) = sumaTiempo(indice) + s{i}(j,3);
    end
end
for i=1:25    
    hold on
    bar(i, sumaTiempo(i)/25)
end

set(gca,'xtick', 1:25)