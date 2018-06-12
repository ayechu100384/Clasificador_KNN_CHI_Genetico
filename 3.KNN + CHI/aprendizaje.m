function [ clasificador ] = aprendizaje(CE, tipoKNN, KF, nClases,numAtr)
    if tipoKNN == 0 %KNN clásico
        clasificador = CE;
    elseif tipoKNN == 1 %KNN difuso
        %añadimos a CE las pertenencias de cada ejemplo a cada clase
       [numEjemplos,~] = size(CE);
       clasificador = [CE,zeros(numEjemplos,nClases)];
       for j=1:numEjemplos
           %distancias sin el bucle
%             distancias = sqrt(sum(ejemplo(i,:)-clasificador(1:end,:)).^2);  
           % Vector Distancia Euclidea para cada ejemplo 
           distancias = zeros(numEjemplos,1);
           for l=1:numEjemplos
               distancias(l) =  sqrt(sum((clasificador(j,1:numAtr+1-1) - clasificador(l,1:numAtr)).^2));
           end
           distancias(j) = Inf;%quitamos el propio elemento
           [~,indices] = sort(distancias);
           %KF vecinos más cercanos
           vecinos = indices(1:KF);
           for i=1:nClases
               if clasificador(j,numAtr+1) == i%la propia clase
                   %repasar la parte del sum
                   clasificador(j,numAtr+1+i) = 0.51 + 0.49 * (sum(clasificador(vecinos,numAtr+1)==i) / KF);
               else
                   clasificador(j,numAtr+1+i) = 0.49 * (sum(clasificador(vecinos,numAtr+1)==i) / KF);
               end
           end
       end
    end
end

