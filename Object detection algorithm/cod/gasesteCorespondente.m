function [Idx, Dist] = gasesteCorespondente( D1, D2 )
  % gaseste corespondetele dintre descriptorii D1 si cuvintele vizuale D2
  % Input:
  %   D1  : matrice NxD de descriptori
  %   D2  : matrice MxD de cuvinte vizuale
  % Output:
  %   Idx : vector Nx1 continand pentru fiecare descriptor din D1 index-ul
  %         cuvantului vizual din D2 cel mai apropiat
  %   Dist: vector Nx1 continand distantele dintre fiecare descriptor din D1 
  %         si cuvantul vizual cel mai apropiat

  N = size(D1,1);
  M = size(D2,1);
  Idx  = zeros(N,1);
  Dist = zeros(N,1);
  
  matriceDistante = pdist2(D1,D2);
  for j=1:N
      Dist(j) = min(matriceDistante(j,:));
      Idx(j) = find(matriceDistante(j,:)==Dist(j),1);
  end
  
end
      