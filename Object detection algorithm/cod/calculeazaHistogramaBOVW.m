function histogramaBOVW = calculeazaHistogramaBOVW(descriptoriHOG, cuvinteVizuale)
  % calculeaza histograma BOVW pe baza descriptorilor si a cuvintelor
  % vizuale, gasind pentru fiecare descriptor cuvantul vizual cel mai
  % apropiat (in sensul distantei Euclidiene)
  %
  % Input:
  %   descriptori: matrice MxD, contine M descriptori de dimensiune D
  %   cuvinteVizuale: matrice NxD, contine N centri de dimensiune D 
  % Output:
  %   histogramaBOVW: vector linie 1xN 
  
 % completati codul
 
  k = size(cuvinteVizuale, 1);
    histImg = zeros(1,k);
    for i=size(descriptoriHOG,1)
        dHOG = descriptoriHOG(i,:);
        distMin = Inf;
        for j=1:k
            dist = sum((dHOG - cuvinteVizuale(j,:)).^2);
            if dist < distMin
                distMin = dist;
                linieOptima = j;
            end
        end    
        histImg(linieOptima) = histImg(linieOptima)+1;
    end
    
    histogramaBOVW = histImg(:);
 
end