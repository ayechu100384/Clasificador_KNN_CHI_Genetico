function [ matConfusion ] = clasificar( clasificador, ejemplos, k, tipoKNN, tipoEj,numClases,numAtr)
%k numero de vecinos
%tipoKNN = 0 clásico, tipoKNN=1 difuso
%tipoEj = 0 ejemplos train, tipoEj=1 ejemplos test
    [numDB,colClases] = size(clasificador);
    [nEjemplos,~] = size(ejemplos);
    matConfusion = zeros(numClases,numClases);
    if tipoKNN == 0 % tipo KNN clásico
        for i=1:nEjemplos
            distancias = zeros(numDB,1); % Vector Distancia Euclidea para cada ejemplo 
            for j=1:numDB
                distancias(j) =  sqrt(sum((ejemplos(i,1:colClases-1) - clasificador(j,1:colClases-1)).^2));
            end
            %distancias = [distancias, distanciaEuclidea(ejemplos(i,:),clasificador(j,:))];
            if tipoEj == 0 %ejemplos de tipo train
                distancias(i) = Inf;%quitamos el propio elemento
            end
            [distancias,indices] = sort(distancias);
            vecinos = indices(1:k);
            %Votos de cada vecino
            votosPorClases = zeros(1,numClases);
            clases = clasificador(vecinos,colClases);
            for z=1:numClases
                votosPorClases(z) = sum( 1./(distancias(1:k)'.^2) .* (z==clases(1:k))'  ); 
            end
            % Construir MatConfusion
            [~,claseEstimada] = max(votosPorClases);
            claseReal = ejemplos(i,colClases);
            matConfusion(claseReal,claseEstimada) = matConfusion(claseReal,claseEstimada)+1;
        end
    elseif tipoKNN == 1 %tipo KNN difuso 
        colClases = numAtr+1;
        for i=1:nEjemplos
            distancias = zeros(numDB,1); % Vector Distancia Euclidea para cada ejemplo 
            for j=1:numDB
                distancias(j) =  sqrt(sum((ejemplos(i,1:colClases-1) - clasificador(j,1:colClases-1)).^2));
            end
            %distancias = [distancias, distanciaEuclidea(ejemplos(i,:),clasificador(j,:))];
            if tipoEj == 0 %ejemplos de tipo train
                distancias(i) = Inf;%quitamos el propio elemento
            end
            [~,indices] = sort(distancias);
            vecinos = indices(1:k);
            %Votos de cada vecino
            votosPorClases = zeros(1,numClases);
            for z=1:numClases
                votosPorClases(z) = sum( 1./(distancias(1:k)'.^2) .* clasificador(vecinos,colClases+z)' ); 
            end
            % Construir MatConfusion
            [~,claseEstimada] = max(votosPorClases);
            claseReal = ejemplos(i,colClases);
            matConfusion(claseReal,claseEstimada) = matConfusion(claseReal,claseEstimada)+1;
        end
        
        
        
       
        
    end
end
                      
