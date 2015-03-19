function histogrameBOVW = calculeazaHistogrameBOVW_director(numeDirector, cuvinteVizuale)
% calculeaza pentru fiecare imagine din directorul numeDirector histograma
% Bag-Of-Visual-Words (BOVW) asociata
% Input:
%       numeDirector - string ce specifica numele directorului in care se gasesc imaginile
%       cuvinteVizuale - matrice K x 128, fiecare linie reprezinta un cuvant vizual (un centru al unui cluster)
%                      - K reprezinta numarul de cuvinte vizuale            
% Output:
%       histogrameBOVW - matrice #Imagini x K, fiecare linie reprezinta histograma BOVW a unei imagini
  
  dimensiuneCelula = 4;
  nrPuncteX = 10;
  nrPuncteY = 10;
  margine = 8;
  
  numeImagini = dir(fullfile(numeDirector,'*.png'));
  numarImagini = length(numeImagini);    
  histogrameBOVW = zeros(numarImagini,size(cuvinteVizuale,1));
  
  % calculeaza histograme BOVW pentru toate imaginile din directorul specificat
  for i=1:numarImagini 
    disp([' Procesam imaginea ' num2str(i) ' ...']);
    
    % citeste imaginea
    img = double(rgb2gray(imread(fullfile(numeDirector,numeImagini(i).name))));

    % genereaza puncte pe un caroiaj pentru fiecare imagine    
    % completati codul
    puncte = genereazaPuncteCaroiaj(img, nrPuncteX, nrPuncteY, margine);
    
    % calculeaza descriptorul HOG pentru fiecare punct
    % completati codul
    [descriptoriHOG, patchuri] = calculeazaHistogrameGradientiOrientati(img, puncte, dimensiuneCelula);
        
    % calculeaza histograma BOW asociata    
    % completati codul
    k = size(cuvinteVizuale, 1);
    histImg = zeros(1,k);
    
    for ii=1:100
        dHOG = descriptoriHOG(ii,:);    
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
    
    histogrameBOVW(i,:) = histImg;
        
  end;
    
end