function clasificaBOVW(histogrameBOVW_test,etichete_test,histogrameBOVW_exemplePozitive,histogrameBOVW_exempleNegative, functieClasificator)
% clasifica histogramele test in functie de un clasificator, exemplele pozitive si cele negative
% Input:
%       histogrameBOVW_test - histogramele ce urmeaza a fi clasificate
%             etichete_test - eticheta histogramelor test
%       histogrameBOVW_exemplePozitive - exemple pozitive (contin masini) de histograme BOVW
%       histogrameBOVW_exempleNegative - exemple negative (NU contin masini) de histograme BOVW
%       functieClasificator - numele unei functii de clasificare (clasificaBOVWCelMaiApropiatVecin, clasificaBOVWBayes)

numarExemple = size(histogrameBOVW_test,1);
pos = 0;
neg = 0;
for i = 1:numarExemple
    % clasifica fiecare histograma
    eticheta = functieClasificator(histogrameBOVW_test(i,:),histogrameBOVW_exemplePozitive,histogrameBOVW_exempleNegative);
    % compara rezultatul cu eticheta adevarata
    if (eticheta == etichete_test(i)) 
        pos = pos + 1; % exemplu clasificat corect            
    else
        neg = neg + 1; % exemplu clasificat incorect
    end
end

disp(['Imagini pozitive: ' num2str(pos)]);
disp(['Imagini negative: ' num2str(neg)]);
disp(['Procentul de imagini clasificate corect:' num2str(pos/numarExemple)]);

end
  