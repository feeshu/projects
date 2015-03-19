function cuvinteVizuale = construiesteVocabular(numeDirector,k,iterMax)
% construieste vocabularul de cuvinte vizuale folosit pentru reprezentarea
% imaginilor ca Bag-of-Visual-Words (sac de cuvinte vizuale)
% Input: 
%       numeDirector - string ce specifica numele directorului in care se gasesc imaginile de antrenare
%                  k - numarul de cuvinte vizuale obtinute in urma clusterizarii cu k-means       
%            iterMax - numarul de iteratii maxime folosite la clustrizarea cu k-means             
% Output: 
%     cuvinteVizuale - matrice k x 128, fiecare linie reprezinta un cuvant vizual (un centru al unui cluster)

  numeImagini = dir(fullfile(numeDirector,'*.png'));
  
  numarImagini = length(numeImagini);
  descriptoriHOG = zeros(0,128); % 16 histograme de dimensiune 8, 16*8 = 128
  patchuri = zeros(0,16*16); % fiecare patch contine 16 x 16 pixeli
  
  dimensiuneCelula = 4;
  nrPuncteX = 10;
  nrPuncteY = 10;
  margine = 8;
  
  % extrage descriptori HOG si patchuri pentru fiecare imagine
  for i=1:numarImagini,
    
    disp([' Procesam imaginea ' num2str(i) ' ...']);
    
    % citeste imaginea
    img = double(rgb2gray(imread(fullfile(numeDirector,numeImagini(i).name))));

    % genereaza puncte caroiaj
    % completati codul aici
    puncteImgCurenta = genereazaPuncteCaroiaj(img, nrPuncteX, nrPuncteY, margine);
    
    % calculeaza descriptorul HOG si patch-ul coespunzator pt fiecare
    % punct de pe caroiaj
    % completati codul aici
    [descriptoriHOGimgCurenta, patchuriImgCurenta] = calculeazaHistogrameGradientiOrientati(img, puncteImgCurenta, dimensiuneCelula);
        
    % pune in descriptoriHOG si patchuri ce ai calculat
    % completati codul aici
    descriptoriHOG((i-1)*100+1:i*100,:) = descriptoriHOGimgCurenta;
    patchuri((i-1)*100+1:i*100,:) = patchuriImgCurenta;
        
  end
  
  disp([' Am extras un numar de ' num2str(size(descriptoriHOG,1)) ' histograme de gradienti orientati']);

  % clusterizare cu kmeans_iter
  disp(' Clusterizare cu kmeans_iter ...');
  cuvinteVizuale = kmeans_iter(descriptoriHOG, k, iterMax);
    
  % vizualizare vocabularul vizual
  disp(' Vizualizam vocabularul vizual ...');
  vizualizeazaVocabular(cuvinteVizuale,descriptoriHOG,patchuri,dimensiuneCelula);
  disp(' Apasati o tasta pentru a continua ...');
  pause;   
end