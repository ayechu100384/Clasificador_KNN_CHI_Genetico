function matConfusion = clasificar(clasificador, ejemplos, K, tipoKNN, tipoEj,pertenencias)    
    [nEjemplos,~] = size(ejemplos);
    [nTra,nAtr] = size(clasificador);
    nClases = max(ejemplos(:,nAtr)); % TENIA CLASIFICADOR EN LUGAR DE EJEMPLOS PERO ES LO MISMO PAR ACOJER EL NCLASES
    matConfusion = zeros(nClases,nClases);
    if tipoKNN ==1
        % Implementacion KNN SIMPLE con distancia euclidea y voto distancia
        for i=1:nEjemplos
            % Vector Distancias Euclideas para cada ejemplo a todos los demas
            vDistEj = zeros(nTra,1);
            for j=1:nTra
                vDistEj(j) =  sqrt(sum((ejemplos(i,1:nAtr-1) - clasificador(j,1:nAtr-1)).^2));
            end
            % Si clasificamos los ejemplos de train, debemos poner la
            % distancia a si mismo a infinito
            if tipoEj == 1
                vDistEj(i) = Inf;
            end
            % Ordenar el Vector de Distancias ascendente (indices)
            [~, I]= sort(vDistEj);       
            % Quedarnos con los K vecinos de menor distancia
            % Calcular cuantos vecinos son de cada clase
            vVot = zeros(nClases,1);
            for c=1:K
                vVot(clasificador(I(c),nAtr)) = vVot(clasificador(I(c),nAtr)) + (1/(vDistEj(I(c))^2)) ;
            end
            [~,claseAsignada] = max(vVot);
            % Construir MatConfusion
            matConfusion(ejemplos(i,nAtr),claseAsignada) =  matConfusion(ejemplos(i,nAtr),claseAsignada)+1;
        end
    else
        % Implementacion KNN FUZZY con distancia euclidea y voto distancia
        for i=1:nEjemplos
            % Vector Distancia Euclidea para cada ejemplo 
            vDistEj = zeros(nTra,1);
            for j=1:nTra
                vDistEj(j) =  sqrt(sum((ejemplos(i,1:nAtr-1) - clasificador(j,1:nAtr-1)).^2));
            end
            % Si clasificamos los ejemplos de train, debemos poner la
            % distancia a si mismo a infinito
            if tipoEj == 1
                vDistEj(i) = Inf;
            end
            % Ordenar el Vector de Distancias ascendente (indices)
            [~, I]= sort(vDistEj);       
            % Quedarnos con los K vecinos de menor distancia
            % Calcular 'cuantos' vecinos son de cada clase
            vVot = zeros(1,nClases);
            for c=1:K
                vVot = vVot  + ((1/(vDistEj(I(c))^2)).*pertenencias(I(c),:));
            end
            [~,claseAsignada] = max(vVot);
            % Construir MatConfusion
            % matConfusion(ejemplos(i,nAtr),clasificador(I(1),nAtr)) =  matConfusion(ejemplos(i,nAtr),clasificador(I(1),nAtr))+1;
            matConfusion(ejemplos(i,nAtr),claseAsignada) =  matConfusion(ejemplos(i,nAtr),claseAsignada)+1;
        end
    end
end

