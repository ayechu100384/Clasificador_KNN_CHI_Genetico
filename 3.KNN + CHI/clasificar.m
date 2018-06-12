function [ matConfusion,clasesPred,infoDudosos,marcas clasesReales] = clasificar( clasificador, ejemplos, k, tipoKNN, tipoEj,numClases,numAtr)
%k numero de vecinos
%tipoKNN = 0 clásico, tipoKNN=1 difuso
%tipoEj = 0 ejemplos train, tipoEj=1 ejemplos test
    [numDB,colClases] = size(clasificador);
    [nEjemplos,~] = size(ejemplos);
    matConfusion = zeros(numClases,numClases);
    votosTotales = [];
    clasesReales = [];
    clasesPred = [];
    infoDudosos = zeros(nEjemplos,1);
    marcas = zeros(nEjemplos,1);
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
            votosTotales = [votosTotales;votosPorClases];
            % Construir MatConfusion
            [~,claseEstimada] = max(votosPorClases);
            clasesPred = [clasesPred;claseEstimada];
            claseReal = ejemplos(i,colClases);
            clasesReales = [clasesReales;claseReal];
            matConfusion(claseReal,claseEstimada) = matConfusion(claseReal,claseEstimada)+1;
            aux = votosPorClases;
            m1 = max(aux);
            aux(aux==m1)=[];
            m2=max(aux);
            infoDudosos(i) = abs(m1-m2);
            marcas(i) = (infoDudosos(i)<=10); 
        end
%         if tipoEj == 1 %ejemplos de tipo test
%                 xlswrite('trabajoKNN.xlsx',clasesPred,'votos','A2');
%                 xlswrite('trabajoKNN.xlsx',marcas,'votos','B2');
%                 xlswrite('trabajoKNN.xlsx',infoDudosos,'votos','C2');
%                 xlswrite('trabajoKNN.xlsx',clasesReales,'votos','D2');
%         end
    elseif tipoKNN == 1 %tipo KNN difuso 
        colClases = numAtr+1;
        % matConfusion,clasesPred,infoDudosos,marcas clasesReales]
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
            clasesPred = [clasesPred;claseEstimada];
            claseReal = ejemplos(i,colClases);
            clasesReales = [clasesReales;claseReal];
            matConfusion(claseReal,claseEstimada) = matConfusion(claseReal,claseEstimada)+1;
            aux = votosPorClases;
            m1 = max(aux);
            aux(aux==m1)=[];
            m2=max(aux);
            infoDudosos(i) = abs(m1-m2);
            marcas(i) = (infoDudosos(i)<=1);   
        end     
        if tipoEj == 1 %ejemplos de tipo test
            xlswrite('proofs.xlsx',clasesPred,'votos','A2');
            xlswrite('proofs.xlsx',marcas,'votos','B2');
            xlswrite('proofs.xlsx',infoDudosos,'votos','C2');
            xlswrite('proofs.xlsx',clasesReales,'votos','D2');
         end
    end
end
                      
