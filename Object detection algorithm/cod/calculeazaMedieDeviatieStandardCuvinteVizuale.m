function [mu, sigma] = calculeazaMedieDeviatieStandardCuvinteVizuale(histogrameBOVW_exemple)
% calculeaza media si deviatia standard asociata fiecarui cuvant vizual
% pentru cuvantul vizual i, mu(i) si sigma(i) reprezinta media si deviatia
% standard a numarului de aparitii ale cuvantului vizual i in imaginile de
% antrenare (pozitive sau negative)
% mu(i) si sigma(i) se calculeaza din coloana i a histogramei BOVW
%
%Input:
%       histogrameBOVW_exemple - matrice M x K, fiecare linie reprezinta histograma BOVW a unei imagini de antrenare (pozitive sau negative)
%Output:
%       mu - matrice 1 x K, fiecare element reprezinta media asociata numarului de aparitii ale fiecarui cuvant vizual i
%       sigma - matrice 1 x K, fiecare element reprezinta deviatia standard asociata numarului de aparitii ale fiecarui cuvant vizual i 
%

% calculati mu si sigma
% completati codul

for i=1:size(histogrameBOVW_exemple, 2)
    mu(i) = mean(histogrameBOVW_exemple(:,i));
    sigma(i) = std(histogrameBOVW_exemple(:,i));
end