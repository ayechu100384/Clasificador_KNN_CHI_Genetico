function [matrizResultados] = aplicaKNN(tipoKNN, k, KF )
numParticiones = 5;
abrirCarpeta = cd;
pathA=[abrirCarpeta '\datasets'];
lista = dir(pathA);
[numDatasets,~] = size(lista);
matrizResultados = zeros(numDatasets-2, 1);
for i = 1:numDatasets-2 % hay que quitar . y ..
    nombreDs = lista (i+2).name;
    pathB = [pathA '\' nombreDs];
    archivos = dir(pathB);
    % porque cuentan los de train y los de test
    % leemos los ejemplos de cada partición de test y train
    fTrain = ['datasets\',nombreDs,'\',nombreDs,'_tra.dat'];
    fTest = ['datasets\',nombreDs,'\',nombreDs,'_tst.dat'];
    disp(fTrain);
    disp(fTest);
    [numAtr, nClases, infoAtr, ejemplosTr, ejemplosTst, ejClase] = lecturaDatos(fTrain, fTest);
    % normalizamos todos los ejemplos
    [ejemplosTr,ejemplosTst] = normalizar(ejemplosTr,ejemplosTst,infoAtr);
    [clasificador] = aprendizaje(ejemplosTr,tipoKNN,KF,nClases,numAtr);          
    [matConfusionTrain] = clasificar(clasificador, ejemplosTr, k, tipoKNN, 0,nClases,numAtr);%0 train
    [matConfusionTest] = clasificar(clasificador, ejemplosTst, k, tipoKNN, 1,nClases,numAtr);%1 test                
    accTrain = rendimiento(matConfusionTrain);
    accTest = rendimiento(matConfusionTest);
    matrizResultados(i) = accTest;
end
end
