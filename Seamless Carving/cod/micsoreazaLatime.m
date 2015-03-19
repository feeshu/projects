function img = micsoreazaLatime(img,numarPixeliLatime,metodaSelectareDrum,ploteazaDrum,culoareDrum)
%micsoreaza imaginea cu un numar de pixeli pe latime (elimina drumuri e sus in jos)
%
%input: img - imaginea initiala
%       numarPixeliLatime - specifica numarul de drumuri de sus in jos eliminate
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

for i = 1:numarPixeliLatime
    
    disp(['Eliminam drumul vertical numarul ' num2str(i) ...
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
    
    %elimina drumul din imagine
    img = eliminaDrumVertical(img,drum);
    
end
