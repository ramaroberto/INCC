promedioSubl = zeros(25,1);
promedioFruta = zeros(25,1);
sumaFruta = zeros(25,1);
sumaSubl = zeros(25,1);
for i=1:length(s)
    resta = ones(length(s{i}),1) - s{i}(:,2);
    [m n] = size(s{i});
    for j=1:m
        indice = s{i}(j,1) - 1;
        promedioFruta(indice) = promedioFruta(indice) + s{i}(j,2)*s{i}(j,3)*s{i}(j,6);
        promedioSubl(indice) = promedioSubl(indice) + resta(j)*s{i}(j,3)*s{i}(j,5);
        sumaFruta(indice) = sumaFruta(indice) + s{i}(j,2)*s{i}(j,6);
        sumaSubl(indice) = sumaSubl(indice) + resta(j)*s{i}(j,5);
    end
end
for i=1:25
    promedioFruta(i) = promedioFruta(i)/(sumaFruta(i)+0.0000000000001);
    promedioSubl(i) = promedioSubl(i)/(sumaSubl(i)+0.0000000000001);
    %bar(i+(i-1)*2, promedioFruta(i))
    %hold on
    %bar(i+(i-1)*2+1,promedioSubl(i))
    %hold on
    
    hold on
    bar(i, promedioSubl(i)-promedioFruta(i))
end

set(gca,'xtick', 1:25)