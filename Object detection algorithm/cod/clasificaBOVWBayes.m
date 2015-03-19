function eticheta = clasificaBOVWBayes( histogramaBOVW_test, histogrameBOVW_exemplePozitive, histogrameBOVW_exempleNegative)
% eticheta = eticheta dedusa prin teorema lui Bayes
%
% Input: 
%       histogramaBOVW_test - matrice 1 x K, histograma BOVW a unei imagini test
%       histogrameBOVW_exemplePozitive - matrice #ImaginiExemplePozitive x K, fiecare linie reprezinta histograma BOVW a unei imagini pozitive
%       histogrameBOVW_exempleNegative - matrice #ImaginiExempleNegative x K, fiecare linie reprezinta histograma BOVW a unei imagini negative
% Output: 
%     eticheta - eticheta dedusa a imaginii test

[muPos, sigmaPos] = calculeazaMedieDeviatieStandardCuvinteVizuale(histogrameBOVW_exemplePozitive);
[muNeg, sigmaNeg] = calculeazaMedieDeviatieStandardCuvinteVizuale(histogrameBOVW_exempleNegative);

% calculati probabilitatea a-posteriori Bayes
% completati codul

X = 0; 
Y = 0;


for i=1:size(histogramaBOVW_test,2)
    X = X + log(normpdf(histogramaBOVW_test(i), muPos(i), sigmaPos(i)));
    Y = Y + log(normpdf(histogramaBOVW_test(i), muNeg(i), sigmaNeg(i)));
end

Pmasina = 0.5 * X / 0.1;        % P(Masina|hist) = P(Masina) * P(hist|Masina) / P(hist)
PnonMasina = 0.5 * Y / 0.1;     % P(NonMasina|hist) = P(NonMasina) * P(hist|NonMasina) / P(hist)

if(Pmasina < PnonMasina)
    eticheta = 0;
else
    eticheta = 1;
end