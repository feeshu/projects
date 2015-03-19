function d = selecteazaDrumVertical(E,metodaSelectareDrum)
%selecteaza drumul vertical ce minimizeaza functia cost calculate pe baza lui E
%input: E - energia la fiecare pixel calculata pe baza gradientului
%       metodaSelectareDrum - specifica metoda aleasa pentru selectarea drumului. Valori posibile:
%                           'aleator' - alege un drum aleator
%                           'greedy' - alege un drum utilizand metoda Greedy
%                           'programreDinamica' - alege un drum folosind metoda Programare Dinamica
% output: d - drumul vertial ales
d = zeros(size(E,1),2);

switch metodaSelectareDrum
    case 'aleator'
        %pentru linia 1 alegem primul pixel in mod aleator
        linia = 1;
        %coloana o alegem intre 1 si size(E,2)
        coloana = randi(size(E,2));
        %punem in d linia si coloana coresponzatoare pixelului
        d(1,:) = [linia coloana];
        for i = 2:size(d,1)
            %alege urmatorul pixel pe baza vecinilor
            %linia este i
            linia = i;
            %coloana depinde de coloana pixelului anterior
            if d(i-1,2) == 1%pixelul este localizat la marginea din stanga
                %doua optiuni
                optiune = randi(2)-1;%genereaza 0 sau 1 cu probabilitati egale 
            elseif d(i-1,2) == size(E,2)%pixelul este la marginea din dreapta
                %am doua optiuni
                optiune = randi(2) - 2; %genereaza -1 sau 0
            else
                optiune = randi(3)-2; % genereaza -1, 0 sau 1
            end
            coloana = d(i-1,2) + optiune;%adun -1 sau 0 sau 1: 
                                         % merg la stanga, dreapta sau stau pe loc
            d(i,:) = [linia coloana];
        end
        
    case 'greedy'
        %pentru linia 1 alegem primul pixel in mod aleator
        linia = 1;
        
        %alegem minimul de pe linia 1
        elemMin = min(E(1,:));
        
        %gasim indexul minimului
        coloana = find(E(1,:)== elemMin,1);
        
        
        %punem in d linia si coloana coresponzatoare pixelului
        d(1,:) = [linia coloana];
        for i = 2:size(d,1)
            %alege urmatorul pixel pe baza vecinilor
            %linia este i
            linia = i;
            %coloana depinde de coloana pixelului anterior
            if d(i-1,2) == 1 %pixelul este localizat la marginea din stanga
                elemMin = min([E(i, coloana) E(i, coloana+1)]);     
                nouaColoana = find(E(i,:) == elemMin, 1);
            elseif d(i-1,2) == size(E,2)%pixelul este la marginea din dreapta             
                elemMin = min([E(i, coloana-1) E(i, coloana)]);    
                nouaColoana = find(E(i,:) == elemMin, 1);
            else %cauta in stanga, centru sau dreapta
                elemMin = min([E(i, coloana-1) E(i, coloana) E(i, coloana+1)]);       
                nouaColoana = find(E(i,:) == elemMin, 1);
            end
            coloana = nouaColoana;              
            d(i,:) = [linia coloana];
        end
        
    case 'programareDinamica'
        M=zeros(size(E));
        M(1,:) = E(1,:);
        
        for i=2:size(M,1)
            for j=1:size(M,2)
                if j==1
                    M(i,j)=E(i,j)+min([M(i-1, j) M(i-1, j+1)]);
                elseif j==size(M,2)
                    M(i,j)=E(i,j)+min([M(i-1,j-1) M(i-1, j)]);
                else
                    M(i,j)=E(i,j)+min([M(i-1, j-1) M(i-1, j) M(i-1,j+1)]);
                end
            end
        end
        %figure, imagesc(M); pause(2); close(gcf);
        linie = size(M,1);
        costMinim = min(M(linie,:));
        coloana = find(M(linie,:)==costMinim,1);
        d(linie, :) = [linie coloana];
        
        for linie=size(M,1)-1:-1:1
            if coloana==1
                if(M(linie, coloana) < M(linie, coloana+1))
                    nouaColoana = coloana;
                else
                    nouaColoana = coloana+1;
                end
            elseif coloana==size(M,2)
                    if(M(linie,coloana-1)<M(linie,coloana))
                        nouaColoana = coloana-1;
                    else
                        nouaColoana = coloana;
                    end
            else
                 v = [M(linie, coloana-1) M(linie, coloana) M(linie, coloana+1)];
                 pozitie = find(v == min(v),1);
                 nouaColoana = coloana + pozitie-2;
            end
            
            coloana = nouaColoana;
            d(linie, :) = [linie, nouaColoana];
        end
                
            
                      
        
    otherwise
        error('Optiune pentru metodaSelectareDrum invalida');
end

end