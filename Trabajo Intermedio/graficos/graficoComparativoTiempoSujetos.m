
h = gca;
xlabels = {};
for i=1:length(s)
    resta = ones(length(s{i}),1) - s{i}(:,2);
    [m n] = size(s{i});
    sumaDivisionFruta = s{i}(:,2)'*s{i}(:,6);
    sumaDivisionSubl = resta'*(s{i}(:,5));
    sumaTiempoFruta = 0;
    sumaTiempoSubl = 0;
    for j=1:m
        sumaTiempoFruta = sumaTiempoFruta + s{i}(j,2)*s{i}(j,3)*s{i}(j,6);
        sumaTiempoSubl = sumaTiempoSubl + resta(j)*s{i}(j,3)*s{i}(j,5);
    end
    promedioFruta = sumaTiempoFruta/sumaDivisionFruta;
    promedioSubl = sumaTiempoSubl/sumaDivisionSubl;
    %bar(i+(i-1)*2, promedioFruta)
    %hold on
    %bar(i+(i-1)*2+1,promedioSubl)
    xlabels = [xlabels, ['s', int2str(i)]];
    hold on
    bar(i, promedioSubl-promedioFruta)
end

% Set the labels
set(gca,'xtick', 1:length(s))
set(gca, 'XTickLabel', xlabels);

