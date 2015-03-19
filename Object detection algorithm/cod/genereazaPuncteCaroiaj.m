function puncteCaroiaj = genereazaPuncteCaroiaj(img,nrPuncteX,nrPuncteY,margine)
% genereaza puncte pe baza unui caroiaj
% un caroiaj este o retea de drepte orizontale si verticale de forma urmatoare:
%
%        |   |   |   |
%      --+---+---+---+--
%        |   |   |   |
%      --+---+---+---+--
%        |   |   |   |
%      --+---+---+---+--
%        |   |   |   |
%      --+---+---+---+--
%        |   |   |   |
%
% Input:
%       img - imaginea input
%       nrPuncteX - numarul de drepte verticale folosit la constructia caroiajului
%                 - in desenul de mai sus aceste drepte sunt identificate cu simbolul |
%       nrPuncteY - numarul de drepte orizontale folosit la constructia caroiajului
%                 - in desenul de mai sus aceste drepte sunt identificate cu simbolul --
%         margine - numarul de pixeli de la marginea imaginii (sus, jos, stanga, dreapta) pentru care nu se considera puncte
% Output:
%       puncteCaroiaj - matrice (nrPuncteX * nrPuncteY) X 2
%                     - fiecare linie reprezinta un punct (y,x) de pe caroiaj aflat la intersectia dreptelor orizontale si verticale
%                     - in desenul de mai sus aceste puncte sunt idenficate cu semnul +

puncteCaroiaj = zeros(nrPuncteX*nrPuncteY,2);
linia = 0;
%completati codul
distX=(size(img,2)-2*margine)/(nrPuncteX-1);
distY=(size(img,1)-2*margine)/(nrPuncteY-1);
for i = 0:nrPuncteX-1 
    for j = 0:nrPuncteY-1
        linia = linia+1;
        puncteCaroiaj(linia,:)=[margine+j*distY,margine+1+i*distX];
    end
end
puncteCaroiaj = round(puncteCaroiaj);
end