function [ AccTrain, AccTest] = runKNNsinBucles( cromosoma )
%Lectura de datos
carpetaPractica = cd;
pathOri = [carpetaPractica '\datasets'];
datasets = dir(pathOri);
nomDsTr = datasets(3).name;
nomDsTst = datasets(4).name;
fTrain = [pathOri '\' nomDsTr ];
fTest =  [pathOri '\' nomDsTst ];
[numAtr, nClases, ~, CE, CT, ~] = lecturaDatos(fTrain, fTest);

%Extraer parámetros del cromosoma
%GEN1: SI ES CLASICO O DIFUSO Y VALOR DE KF   
KF=cromosoma(1);
%GEN2: VALOR DE K
%K=cromosoma(2); lo hacemos mas adelante
%GEN(3:3+numAtr)Seleccion Variables segun indique el cromosoma
varLogic = cromosoma(3:3+numAtr-1);
varLogic = [varLogic 1];% para coger la clase cuando los montamos
%GEN(3+numAtr+1:end)Seleccion Ejemplos segun indique el cromosoma
ejLogic = cromosoma(3+numAtr:end);
% Montamos CE y CT especificados en el cromosoma variables y ejemplos
CE = CE(logical(ejLogic),logical(varLogic));
CT = CT(:,logical(varLogic));
% Normalizacion max min
CE = normalizaMaxMin( CE );
CT = normalizaMaxMin( CT );
%definición de los parametros a utilizar por KNN sin bucles
dataset.training = CE; %datos de train
dataset.test = CT; %datos de test
dataset.numClasses = nClases; %numero de clases
%parametros e la ejecucion de KNN
isTrain = 1; %indicamos que los datos a clasificar son de train
voteType = 'pond'; %voto ponderado por la inversa de la distacia
K = cromosoma(2); % vecinos indicados en el cromosoma
distType = 'Euclidea'; %distancia euclidea
numTrain = size(CE, 1); %numero de ejemplos de train
numTest = size(CE, 1); %numero de ejemplos de test (como estamos clasificando el train estos dos parametros son iguales)
%llamada a knn sin bluces: devuelve un vector con las clases predichas para cada ejemplo de train
result = knnTest(dataset,numTest,numTrain,distType,K,voteType,isTrain);
%obtenemos el porcentaje de aceirto de train
AccTrain = sum(result'==CE(:,end))/numTest;

%clasificacion de los datos de test
isTrain = 0; %indicamos que los datos a clasificar son de test
numTest = size(CT, 1); %número de ejemplos de test
%llamada a knn sin bluces: devuelve un vector con las clases predichas para cada ejemplo de test
result = knnTest(dataset,numTest,numTrain,distType,K,voteType,isTrain);
%obtenemos el porcentaje de aceirto de test
AccTest = sum(result'==CT(:,end))/numTest;

end

