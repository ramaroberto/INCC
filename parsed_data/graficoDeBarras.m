
vectorSubliminal = ones(1,length(s));
vectorTresIm = ones(1,length(s));
vectorIncorrecto = ones(1,length(s));

for i=1:length(s)
    
    vectorSubliminal(i) = sum(s{i}(:,5));
    vectorTresIm(i) = sum(s{i}(:,6));
    vectorIncorrecto(i) = sum(s{i}(:,7));
end
sumaS = sum(vectorSubliminal);
sumaT = sum(vectorTresIm);
sumaI = sum(vectorIncorrecto);

bar(1, sumaS);
hold on
bar(3, sumaT);
hold on
bar(5, sumaI);
