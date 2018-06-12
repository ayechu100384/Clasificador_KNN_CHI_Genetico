function [clasificador,pertenencias] = aprendizaje(CE, tipoKNN, KF)
    % @param CE: Conjto de ejemplos de Entrenamiento o train
    % @param tipoKNN: valor 1 si es KNNSimple or valor 2 si es KNNFuzzy
    % @param KF: numero de vecinos que se tomarán en cuenta en el KNNFuzzy para
    %           el cáclculo de pertenencias a cada clase    
    % @param clasificador:  es el propio cjto de entrenamento
    [nEjemplos,~] = size(CE);
    nClases = max(CE(:,end));
    clasificador = CE;
    if tipoKNN ==1      % ------KNN SIMPLE-----
        %En el KNN normal no hay fase de aprendizaje
        pertenencias = [];
    else                % ------KNN DIFUSO-----
        % Necesario un preprocesamiento de los datos de entrenamiento
        % KF es el numero de vecinos que se toman en cuenta para el calculo
        % de las pertenencias a cada clase
        % @param pertenencias: es uma matriz que indica el grado de pertenencia de
        % cada ejemplo a cada clase
        pertenencias = zeros(nEjemplos,nClases);
        for i = 1: nEjemplos
            % Vector Distancia Euclidea para cada ejemplo
            vDistEj = zeros(nEjemplos,1);
            for j=1:nEjemplos
                vDistEj(j) = sqrt(sum((CE(i,1:end-1) - CE(j,1:end-1)).^2));
            end
            % Distancia a si mismo = Inf
            vDistEj(i) =Inf; 
            % Nos quedamos con los KF vecinos mas cercanos
            [~, I]= sort(vDistEj); 
            vecinos = clasificador(I(1:KF),:);
            claseEj = clasificador(i,end);      
            for k=1:nClases
                vCk = sum(vecinos(:,end)==k); % nVecinos de la clase del ejemplo que calculamos
                if claseEj ==k
                    pertenencias(i,k) = 0.51+(vCk/KF)*0.49;
                else
                    pertenencias(i,k) = (vCk/KF)*0.49;
                end
            end
        end
    end
end

