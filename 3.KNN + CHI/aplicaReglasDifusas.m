function [matrizResultados,prediccionTr] = aplicaReglasDifusas(tipoAgregacion,tipoPeso)
    tic;
    num_labels = 3;
    numParticiones = 5;
    abrirCarpeta = cd;
    prediccion = [];
    pathA=[abrirCarpeta '\datasets'];
    lista = dir(pathA);
    [numDatasets,~] = size(lista);
    matrizResultados = zeros(numDatasets-2,1);
    for i = 1:numDatasets-2%hay que quitar . y ..
        nombreDs = lista(i+2).name;
        pathB = [pathA '\' nombreDs];
        archivos = dir(pathB);
        %porque cuentan los de train y los de test
        %leemos los ejemplos de cada partición de test y train
        fTrain = ['datasets\',nombreDs,'\',nombreDs,'_tra.dat'];
        fTest = ['datasets\',nombreDs,'\',nombreDs,'_tst.dat'];
        disp(fTrain);
        disp(fTest);
        [numAtr, nClases, infoAtr, CE, CT, numEjClase] = lecturaDatos(fTrain, fTest);
        fuzzyDataTrain = fuzzify(num_labels,CE,infoAtr);
        fuzzyDataTest = fuzzify(num_labels,CT,infoAtr);
        reglas = generaReglasDifusas(fuzzyDataTrain,num_labels,tipoPeso);
        [matConfusionTrain,prediccionTr] = clasificarReglas(reglas, fuzzyDataTrain, tipoAgregacion, nClases);
        [matConfusionTest,prediccion] = clasificarReglas(reglas, fuzzyDataTest, tipoAgregacion, nClases);               
        accTrain = rendimiento(matConfusionTrain);
        accTest = rendimiento(matConfusionTest);
        matrizResultados(i) = accTest;
    end 
    %almacenar en una hoja excel
    tiempo = toc;
    if tipoPeso == 0
        nombre = 'confianza no penalizada';
    else 
        nombre = 'confianza penalizada';
    end
    if tipoAgregacion == 0
        nombre = [nombre,' Máximo'];
    else 
        nombre = [nombre,' Suma'];
    end
end
