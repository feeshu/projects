%Implementarea a proiectului Redimensionare imagini
%dupa articolul "Seam Carving for Content-Aware Image Resizing", autori S.
%Avidan si A. Shamir
%

im = input('Introduceti numele pozei: ', 's');
myDir = '../data/';

%citim imaginea
img = imread([myDir im]);
[inaltime, latime, c] = size(img);
culoareDrum = [255 0 0]';%culoarea rosie
metodaSelectareDrum = 'programareDinamica';%optiuni posibile: 'aleator','greedy','programareDinamica'

rez = input('Alegeti o optiune: \n (1) Micsorarea imaginii. \n (2) Marirea imaginii. \n (3) Eliminarea unui obiect din imagine. \n');

switch rez
    case 1
        numarPixeliLatime = input('Latimea in pixeli: ');
        numarPixeliInaltime = input('Inaltimea in pixeli: ');
        ploteazaDrum = input('Ploteaza drumul optim? 1 = DA; 0 = NU: ');
        
        imgL = micsoreazaLatime(img,numarPixeliLatime,metodaSelectareDrum,...
        ploteazaDrum,culoareDrum);

        %reduce inaltimea in inaltime
        imgI = micsoreazaInaltime(imgL,numarPixeliInaltime,metodaSelectareDrum,...
        ploteazaDrum,culoareDrum);

        %foloseste functia imresize pentru redimensionare traditionala
        imgT = imresize(img, [size(imgI,1) size(imgI,2)]);

        %ploteaza imaginile obinute: imaginea initiala, imaginea redimensionata cu
        %pastrarea continutului, imaginea obtinuta prin redimensionare traditionala
        figure, imshow(img), title('imagine initiala');
        figure, imshow(imgI), title('imagine micsorata de alg. nostru');
        figure, imshow(imgT), title('imagine redimensionata traditional');
        
        break
        
        
        
    case 2        
        numarPixeliLatime = input('Latimea in pixeli: ');
        numarPixeliInaltime = input('Inaltimea in pixeli: ');
        ploteazaDrum = input('Ploteaza drumul optim? 1 = DA; 0 = NU: ');
        
        %adauga pixeli in latime si in inaltime
        imgM = maresteLatime(img,numarPixeliLatime,metodaSelectareDrum,...
         ploteazaDrum,culoareDrum);
        imgm = maresteInaltime(imgM,numarPixeliInaltime,metodaSelectareDrum,...
        ploteazaDrum,culoareDrum);
    
        imgT = imresize(img, [size(imgm,1) size(imgm,2)]);
 
        figure, imshow(img), title('imagine initiala');
        figure, imshow(imgm), title('imagine marita de alg. nostru');
        figure, imshow(imgT), title('imagine redimensionata traditional');
        
        break
        
    case 3        
        ploteazaDrum = input('Ploteaza drumul optim? 1 = DA; 0 = NU: ');
        
        %elimina obiect
        imgRem = eliminaObiect(img, metodaSelectareDrum, ploteazaDrum, culoareDrum);

        figure, imshow(img, []), title('imagine initiala');
        figure, imshow(imgRem, []), title('obiectul sters de alg. nostru');
        
        
    otherwise
        fprintf('Nicio optiune selectata.')
end