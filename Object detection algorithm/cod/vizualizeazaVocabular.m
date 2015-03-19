function vizualizeazaVocabular(cuvinteVizuale,descriptoriHOG,patches,dimensiuneCelula)
% vizualizeaza patch-urile extrase din imagini care corespund cel mai bine 
% cuvintelor vizuale ce alcatuiesc vocabularul

latimePatch = 4*dimensiuneCelula;
inaltimePatch = 4*dimensiuneCelula;

clusterPatches = zeros(inaltimePatch,latimePatch,1,0);
scores = zeros(0,0);

[idx,dist] = gasesteCorespondente(descriptoriHOG,cuvinteVizuale);

% afla patch-ul cel mai apropiat de cuvantulVizual curent
for i = 1:size(cuvinteVizuale,1)
    
    matching = find(idx==i);
    
    if (matching)
        
        [d,smallest] = min(dist(matching));
        closestIdx = matching(smallest);
              
        p = reshape(patches(closestIdx,:),inaltimePatch,latimePatch,1);
        clusterPatches(:,:,:,end+1) = p;
        scores(end+1)=length(matching);
        
    end
    
end

[sortedScores,scoreOrder] = sort(scores,'descend');
clusterPatches=clusterPatches(:,:,:,scoreOrder);

montage(clusterPatches, 'DisplayRange', []);

end
