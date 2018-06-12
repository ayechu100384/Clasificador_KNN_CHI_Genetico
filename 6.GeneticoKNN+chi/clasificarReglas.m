function [matConfusionTrain,prediccion] = clasificarReglas(reglas, ejemplosTr, tipoAgregacion,numClases)
    %tipoAgregacion = 0 -> maximo
    %tipoAgregacion = 1 -> suma
    numReglas = size(reglas,1);
    numEjemplos = size(ejemplosTr,1);
    gradoCompatibilidad = zeros(1,numReglas);
    gradoAsociacion = zeros(1,numReglas);
    gradoAsociacionPorClases = zeros(numClases,1);
    prediccion = zeros(numEjemplos,1);
    for i=1:numEjemplos
        for k=1:numReglas
            %reglas end-2 quitar clase y peso
            %ejemposTr-1 quitar la clase
            %multiplicamos las columnas del ejemplo que marca la regla
            gradoCompatibilidad(k) = prod(ejemplosTr(i,reglas(k,1:end-2)));
            gradoAsociacion(k) = gradoCompatibilidad(k)*reglas(k,end);
        end
        %habría que quitar los ceros de gradoAsociacion para otras
        %agregaciones
        if tipoAgregacion == 0%Maximo
            for c=1:numClases
                if isempty( gradoAsociacion( reglas(:,end-1)==c) )==1
                    gradoAsociacionPorClases(c) =0;
                else
                    gradoAsociacionPorClases(c) = max( gradoAsociacion( reglas(:,end-1)==c)  );
                end
            end
        end
        if tipoAgregacion == 1%Suma
            for c=1:numClases
                if isempty( gradoAsociacion( reglas(:,end-1)==c)  )==1
                    gradoAsociacionPorClases(c) =0;
                else
                    gradoAsociacionPorClases(c) = sum( gradoAsociacion( reglas(:,end-1)==c) ) ;
                end
            end
        end
        [~,prediccion(i)] = max(gradoAsociacionPorClases);
    end
    matConfusionTrain = confusionmat(ejemplosTr(:,end),prediccion);
end