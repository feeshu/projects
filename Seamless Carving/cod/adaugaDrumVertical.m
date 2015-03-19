function img1 = adaugaDrumVertical(img,drum)
%elimina drumul vertical din imagine
%input: img - imaginea initiala
%       drum - drumul vertical
%output img1 - imaginea initiala in care s-a adaugat drumul vertical
img1 = zeros(size(img,1),size(img,2)+1,size(img,3),'uint8');

for i=1:size(img1,1)
        coloana = drum(i,2);
        %copiem partea din stanga
        img1(i,1:coloana,:) = img(i,1:coloana,:);
        
        %copiem drumul optim in noua imagine ca medie a celor 2 drumuri
        %vecine
        img1(i,coloana+1,:) = img(i,((coloana-1)+(coloana+1))/2,:);

        %copiem partea din dreapta
        img1(i, coloana+2:size(img1,2),:) = img(i, coloana+1:size(img,2),:);
end