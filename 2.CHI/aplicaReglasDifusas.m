function [matrizResultados] = aplicaReglasDifusas(tipoAgregacion,tipoPeso)
    num_labels = 3;
    numParticiones = 5;
    abrirCarpeta = cd;
    pathA=[abrirCarpeta '\datasets'];
    lista = dir(pathA);
    [numDatasets,~] = size(lista);
    tiempo = zeros(numDatasets-2,1);
    numReglas = zeros(numDatasets-2,1);
    matrizResultados = zeros(numDatasets-2, numParticiones+1);
    for i = 1:numDatasets-2%hay que quitar . y ..
        nombreDs = lista(i+2).name;
        pathB = [pathA '\' nombreDs];
        archivos = dir(pathB);
        [numArchivos] = size(archivos,1);
        for j=1:(numArchivos-2)/2 %porque cuentan los de train y los de test
            %leemos los ejemplos de cada partición de test y train
            fTrain = ['datasets\',nombreDs,'\',nombreDs,'-5-',int2str(j),'tra.dat'];
            fTest = ['datasets\',nombreDs,'\',nombreDs,'-5-',int2str(j),'tst.dat'];
            disp(fTrain);
            disp(fTest);
            [numAtr, nClases, infoAtr, CE, CT, numEjClase] = lecturaDatos(fTrain, fTest);
            fuzzyDataTrain = fuzzify(num_labels,CE,infoAtr);
            fuzzyDataTest = fuzzify(num_labels,CT,infoAtr);
            tic;
            reglas = generaReglasDifusas(fuzzyDataTrain,num_labels,tipoPeso);
            numReglas(i) = numReglas(i) + size(reglas,1);
            [matConfusionTrain] = clasificarReglas(reglas, fuzzyDataTrain, tipoAgregacion, nClases);
            [matConfusionTest] = clasificarReglas(reglas, fuzzyDataTest, tipoAgregacion, nClases);  
            tiempo(i) = tiempo(i) + toc;
            accTrain = rendimiento(matConfusionTrain);
            accTest = rendimiento(matConfusionTest);
            matrizResultados(i,j) = accTest;
        end
    end
    matrizResultados(:,numParticiones+1) = mean(matrizResultados(:,1:end-1),2); 
    %almacenar en una hoja excel
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
    xlswrite('Practica6ReglasChi.xlsx',{'appendicitis';'balance';'bands';'bupa';'ecoli';'haberman';'iris';'newthyroid';'pageblocks';'wine'},nombre,'A2');
    xlswrite('Practica6ReglasChi.xlsx',{'p1','p2','p3','p4','p5','media','num reglas','tiempo'},nombre,'B1');
    xlswrite('Practica6ReglasChi.xlsx',[matrizResultados,numReglas,tiempo],nombre,'B2');
end
