
vectorSubliminal = ones(1,length(s));
vectorTresIm = ones(1,length(s));
vectorIncorrectoSubliminal = ones(1,length(s));
vectorIncorrectoTres = ones(1,length(s));

for i=1:length(s)
    
    vectorSubliminal(i) = sum(s{i}(:,5));
    vectorTresIm(i) = sum(s{i}(:,6));
    vectorIncorrectoSubliminal(i) = s{i}(:,2)'*s{i}(:,7);
    vectorIncorrectoTres(i) = (ones(length(s{i}),1)-s{i}(:,2))'*s{i}(:,7);
    
end
sumaS = sum(vectorSubliminal);
sumaT = sum(vectorTresIm);
sumaIS = sum(vectorIncorrectoSubliminal);
sumaIT = sum(vectorIncorrectoTres);

bar(1, sumaS);
hold on
bar(3, sumaT);
hold on
bar(5, sumaIS);
hold on
bar(7, sumaIT);
