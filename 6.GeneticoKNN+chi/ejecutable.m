clear all;
load('sol.mat');
%Llamada a KNN con el mejor cromosoma
%k = 7, kf=10
[aciertosKNNTest,aciertosKNNTrain,prediccionKNNTest,prediccionKNNTrain,marcasTst,marcasTr,clasesRealesTst,clasesRealesTr] = aplicaKNNGenetic( CromSolucion );

%llamada a genera reglas de chi
%tipoAgregacion: 0 -> maximo,  1 -> suma
%tipoPeso: 0 -> no penalizada,  1 -> penalizada
aciertosCHITest = zeros(1,4);
aciertosCHITrain = zeros(1,4);
prediccionChiTest = zeros(length(prediccionKNNTest),4);
prediccionChiTrain = zeros(length(prediccionKNNTrain),4);
tipoAg = 0;
tipoPeso =1;
cont = 1;
for tipoAg = 0:1
    for tipoPeso=0:1
        [matrizResultados,aciertosCHITest(cont),aciertosCHITrain(cont),prediccionChiTest(:,cont),prediccionChiTrain(:,cont)] = aplicaReglasDifusas(CromSolucion,tipoAg,tipoPeso);
        cont = cont+1;
    end
end

%Ensamblar Train
aleatorios = round(rand(length(prediccionChiTrain),1));
%aleatorios = ones(length(prediccionChiTrain),1);probando a cambiar todos
%los dudosos
prediccion = zeros(size(prediccionChiTrain));
aciertos = zeros(size(aciertosCHITrain));
for i=1:4
    aux = prediccionKNNTrain;
    aux(logical(aleatorios(marcasTr==1))) = prediccionChiTrain(logical(aleatorios(marcasTr==1)),i);
    prediccion(:,i) = aux;
    aciertos(i) = sum (aux==clasesRealesTr) / length(aux);
end

%Con el mejor resultado de train, ensamblar Test
[~,mejor] = max(aciertos);
prediccionTest = prediccionKNNTest;
prediccionTest(logical(aleatorios(marcasTst==1))) = prediccionChiTest(logical(aleatorios(marcasTst==1)),mejor);
aciertosTest = sum (prediccionTest==clasesRealesTst) / length(prediccionTest);
