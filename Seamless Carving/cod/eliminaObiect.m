function img = eliminaObiect(img, metodaSelectareDrum,ploteazaDrum,culoareDrum)

%metoda pentru selectarea unui obiect din imagine
imshow(img)
selectie = getrect;

x = selectie(1);
y = selectie(2);
latime = selectie(3);
inaltime = selectie(4);



%pentru pixelii din obiectul selectat, asociem energia cu valoarea -1000


%stabilim daca latimea < inaltimea
if(latime < inaltime)
    
    Ef = zeros(size(img,1), size(img,2));
    
    for i=int16(y):int16((y+inaltime-1))
        for j=int16(x):int16(x+latime-1)
            Ef(i,j) = -1000;
        end
    end
    
    for i = 1:latime
        
        E = calculeazaEnergie(img);
        disp(['Eliminam obiectul selectat: ' num2str(i*100/latime) ...
            '%' ]);
        
        %alege drumul vertical care conecteaza sus de jos
        drum = selecteazaDrumVertical(double(E)+double(Ef),metodaSelectareDrum);
        
        %afiseaza drum
        if ploteazaDrum
            ploteazaDrumVertical(img,double(E)+double(Ef),drum,culoareDrum);
            pause(0.3);
            close(gcf);
        end
        
        %elimina drumul din imagine
        img = eliminaDrumVertical(img,drum);
        Ef = eliminaDrumVerticaldif(Ef, drum);
    end
    
else 
    
    Ef = zeros(size(img,2), size(img,1));
    
    %rotim imaginea 90 grade
    imgRot = imrotate(img,-90);
    imgFlip = flipdim(imgRot, 2);
    
    %calculam energia pentru imaginea rotita
    % E = calculeazaEnergie(imgFlip);
    
    %asociem energia negativa pentru obiectul rotit
    for i=int16(y):int16((y+inaltime-1))
        for j=int16(x):int16(x+latime-1)
            Ef(j,i) = -1000;
        end
    end
    
    for i = 1:inaltime
        
        E = calculeazaEnergie(imgFlip);
        
        disp(['Eliminam obiectul selectat: ' num2str(i*100/inaltime) ...
            '%' ]);
        
        
        %alege drumul orizontal care conecteaza stanga de dreapta (in cazul
        %nostru sus de jos, pentru ca imaginea este rotita, deci se va folosi
        %aceeasi functie de selectare a drumului vertical.
        
        drum = selecteazaDrumVertical(double(E)+double(Ef),metodaSelectareDrum);
        
        %afiseaza drum
        if ploteazaDrum
            ploteazaDrumVertical(imgFlip,double(E)+double(Ef),drum,culoareDrum);
            pause(0.3);
            close(gcf);
        end
        
        %elimina drumul din imagine
        imgFlip = eliminaDrumVertical(imgFlip,drum);
        Ef = eliminaDrumVerticaldif(Ef, drum);
        
        %readucem imaginea in pozitia initiala
        imgRot = flipdim(imgFlip, 2);
        img = imrotate(imgRot, 90);
        
    end
end


