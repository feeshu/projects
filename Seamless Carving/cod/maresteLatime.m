function img = maresteLatime(img,numarPixeliLatime,metodaSelectareDrum,ploteazaDrum,culoareDrum)

matriceDrumuri = zeros(size(img,1), numarPixeliLatime);

for i = 1:numarPixeliLatime   
 
    
    disp(['Adaugam drumul vertical numarul ' num2str(i) ...
        ' dintr-un total de ' num2str(numarPixeliLatime)]);
    
    %calculeaza energia dupa ecuatia (1) din articol
    E = calculeazaEnergie(img);
    
    %alege drumul vertical care conecteaza sus de jos
    drum = selecteazaDrumVertical(E,metodaSelectareDrum);
    
    %afiseaza drum
    if ploteazaDrum
        ploteazaDrumVertical(img,E,drum,culoareDrum);
        pause(0.1);
        close(gcf);
    end
    
    matriceDrumuri(:, i) = drum(:,2);
    
    %adauga drumul in imagine
    img = adaugaDrumVertical(img,drum);

end

