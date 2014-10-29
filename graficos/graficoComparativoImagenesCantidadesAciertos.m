cuentaCorrectas = zeros(25,1);
cuentaIncorrectas = zeros(25,1);
for i=1:length(s)
    resta = ones(length(s{i}),1) - s{i}(:,2);
    for j=1:length(s{i})
        indice = s{i}(j,1) - 1;
        if s{i}(j,6) == 1 || s{i}(j,5) == 1
            cuentaCorrectas(indice) = cuentaCorrectas(indice) + 1;
        else
            cuentaIncorrectas(indice) = cuentaIncorrectas(indice) + 1;
        end
    end
end
for i=1:25    
    hold on
    bar(i, cuentaCorrectas(i)-cuentaIncorrectas(i))
end

set(gca,'xtick', 1:25)