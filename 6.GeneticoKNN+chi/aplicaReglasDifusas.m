function [matrizResultados,accTest,accTrain,prediccionTest,prediccionTr] = aplicaReglasDifusas(cromosoma,tipoAgregacion,tipoPeso)
    tic;
    num_labels = 3;
    numParticiones = 5;
    abrirCarpeta = cd;
    prediccion = [];
    %variables para leerlos datos
    matrizResultados = zeros(1,1);
    carpetaPractica = cd;
    pathOri = [carpetaPractica '\datasets'];
    datasets = dir(pathOri);
    nomDsTr = datasets(3).name;
    nomDsTst = datasets(4).name;
    fTrain = [pathOri '\' nomDsTr ];
    fTest =  [pathOri '\' nomDsTst ];
    disp(fTrain);
    disp(fTest);
    [numAtr, nClases, infoAtr, CE, CT, numEjClase] = lecturaDatos(fTrain, fTest);
    %GEN(3:3+numAtr)Seleccion Variables segun indique el cromosoma
    varLogic = cromosoma(3:3+numAtr-1);
    infoAtr = infoAtr(logical(varLogic),:);
    varLogic = [varLogic 1];% para coger la clase cuando los montamos
    %GEN(3+numAtr+1:end)Seleccion Ejemplos segun indique el cromosoma
    ejLogic = cromosoma(3+numAtr:end);
    % Montamos CE y CT
    CE = CE(logical(ejLogic),logical(varLogic));
    CT = CT(:,logical(varLogic));
    %fuzzify
    fuzzyDataTrain = fuzzify(num_labels,CE,infoAtr);
    fuzzyDataTest = fuzzify(num_labels,CT,infoAtr);
    %aprendizaje y clasificación
    reglas = generaReglasDifusas(fuzzyDataTrain,num_labels,tipoPeso);
    [matConfusionTrain,prediccionTr] = clasificarReglas(reglas, fuzzyDataTrain, tipoAgregacion, nClases);
    [matConfusionTest,prediccionTest] = clasificarReglas(reglas, fuzzyDataTest, tipoAgregacion, nClases);               
    accTrain = rendimiento(matConfusionTrain);
    accTest = rendimiento(matConfusionTest);
    matrizResultados = accTest;
end
