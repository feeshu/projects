function E = calculeazaEnergie(img)
%calculeaza energia la fiecare pixel pe baza gradientului
%input: img - imaginea initiala
%output: E - energia

img = rgb2gray(img);%transforma imaginea
f = -fspecial('sobel');%foloseste filtrul sobel
Gx = imfilter(int16(img),f','replicate');%gradientul in directia x                                 
Gy = imfilter(int16(img),f,'replicate');%gradientul in directia y
E = sqrt(double(Gx.^2+Gy.^2));