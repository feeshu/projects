function img = micsoreazaInaltime(img,numarPixeliInaltime,metodaSelectareDrum,ploteazaDrum,culoareDrum)
%micsoreaza imaginea cu un numar de pixeli pe inaltime (elimina drumuri e sus in jos)
%
%input: img - imaginea initiala
%       numarPixeliInaltime - specifica numarul de drumuri de sus in jos eliminate
%       metodaSelectareDrum - specifica metoda aleasa pentru selectarea drumului. Valori posibile:
%                           'aleator' - alege un drum aleator
%                           'greedy' - alege un drum utilizand metoda Greedy
%                           'programreDinamica' - alege un drum folosind metoda Programare Dinamica
%       ploteazaDrum - specifica daca se ploteaza drumul gasit. Valori posibile
%                    0 - nu se ploteaza
%                    1 - se ploteaza
%       culoareDrum  - specifica culoarea cu care se vor plota pixelii din drum. Valori posibile:
%                    [r b g]' - triplete RGB (e.g [255 0 0]' - rosu)
%
% output: img - imaginea redimensionata obtinuta prin eliminarea drumurilor

imgRot = imrotate(img,-90);
% Se roteste imaginea cu 90 de grade CW.

for i = 1:numarPixeliInaltime
    
    disp(['Eliminam drumul orizontal numarul ' num2str(i) ...
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
    
    %elimina drumul din imagine
    imgRot = eliminaDrumVertical(imgRot,drum);
    
    %readucem imaginea in pozitia initiala
    img = imrotate(imgRot, 90);
    
end

