function img = maresteLatime(img,numarPixeliInaltime,metodaSelectareDrum,ploteazaDrum,culoareDrum)

   imgRot = imrotate(img,-90);
% Se roteste imaginea cu 90 de grade CW.
   matriceDrumuri = zeros(size(imgRot,1), numarPixeliInaltime);
for i = 1:numarPixeliInaltime
    
    disp(['Adaugam drumul orizontal numarul ' num2str(i) ...
        ' dintr-un total de ' num2str(numarPixeliInaltime)]);
    
    %calculeaza energia dupa ecuatia (1) din articol
    E = calculeazaEnergie(imgRot);
    
    %alege drumul orizontal care conecteaza stanga de dreapta (in cazul
    %nostru sus de jos, pentru ca imaginea este rotita, deci se va folosi
    %aceeasi functie de selectare a drumului vertical.
    
    drum = selecteazaDrumVertical(E,metodaSelectareDrum);
    
    %afiseaza drum
    if ploteazaDrum
        ploteazaDrumVertical(imgRot,E,drum,culoareDrum);
        pause(0.1);
        close(gcf);
    end
    matriceDrumuri(:, i) = drum(:,2);
    
    %elimina drumul din imagine
    imgRot = adaugaDrumVertical(imgRot,drum);
    
    %readucem imaginea in pozitia initiala
    img = imrotate(imgRot, 90);


end

