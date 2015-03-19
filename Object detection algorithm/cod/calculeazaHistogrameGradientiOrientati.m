function [descriptoriHOG, patchuri] = calculeazaHistogrameGradientiOrientati(img,puncte,dimensiuneCelula)
% calculeaza pentru fiecare punct din de pe caroiaj, histograma de gradienti orientati
% corespunzatoare dupa cum urmeaza:
%  - considera cele 16 celule inconjuratoare si calculeaza pentru fiecare
%  celula histograma de gradienti orientati de dimensiune 8;
%  - concateneaza cele 16 histograme de dimeniune 8 intr-un descriptor de
%  lungime 128 = 16*8;
%  - fiecare celula are dimensiunea dimensiuneCelula x dimensiuneCelula (4x4 pixeli)
%
% Input:
%       img - imaginea input
%    puncte - puncte de pe caroiaj pentru care calculam histograma de
%             gradienti orientati
%   dimensiuneCelula - defineste cat de mare este celula
%                    - fiecare celula este un patrat continand
%                      dimensiuneCelula x dimensiuneCelula pixeli
% Output:
%        descriptoriHOG - matrice #Puncte X 128
%                       - fiecare linie contine histograme de gradienti
%                        orientati calculata pentru fiecare punct de pe
%                        caroiaj
%               patchuri - matrice #Puncte X (16 * dimensiuneCelula^2)
%                       - fiecare linie contine pixelii din cele 16 celule
%                         considerati pe coloana

nBins = 8; %dimensiunea histogramelor fiecarei celule

descriptoriHOG = zeros(0,nBins*4*4); % fiecare linie reprezinta concatenarea celor 16 histograme corespunzatoare fiecarei celule
patchuri = zeros(0,4*dimensiuneCelula*4*dimensiuneCelula); %


if size(img,3)==3
    img = rgb2gray(img);
end
img = double(img);

f = [-1 0 1];
Ix = imfilter(img,f,'replicate');
Iy = imfilter(img,f','replicate');

orientare = atand(Ix./(Iy+eps)); %unghiuri intre -90 si 90 grade
orientare = orientare + 90; %unghiuri intre 0 si 180 grade

lungimeInterval = 180/8;
centriIntervale = lungimeInterval/2 : lungimeInterval : 180-lungimeInterval/2;

contorPuncte = 0;

%completati codul
for i=1:size(puncte,1)
    contorPuncte = contorPuncte+1;
    y = puncte(i,1);
    x = puncte(i,2);
    patch = img(y-7:y+8,x-8:x+7);
    orientarePatch = orientare(y-7:y+8,x-8:x+7);
    contorCelula = 0;
    for y = 1:4
        for x = 1:4
            contorCelula = contorCelula+1;
            patchCelula = patch((y-1)*4+1:y*4, (x-1)*4+1:x*4);
            orientarePatchCelula = orientarePatch((y-1)*4+1:y*4, (x-1)*4+1:x*4);
            histCelula(:,  contorCelula) = hist(orientarePatchCelula(:), centriIntervale);
        end
    end  
    descriptoriHOG(contorPuncte,:) = histCelula(:);
   
    patchuri(contorPuncte,:) = patch(:);
end






        
