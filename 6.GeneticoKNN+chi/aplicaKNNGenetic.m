function [ AccTst,AccTr, clasesPredTst, clasesPredTr ,marcasTst,marcasTr,clasesRealesTst,clasesRealesTr] = aplicaKNNGenetic( cromosoma )  
%Extraemos variables del cromosoma
    %GEN1: SI ES CLASICO O DIFUSO Y VALOR DE KF
    if cromosoma(1)==0
        tipoKNN=1;
    else
        tipoKNN=2;
    end
    KF=cromosoma(1);
    %GEN2: VALOR DE K
    K=cromosoma(2);
    %Este algoritmo unicamente nos sirve para calcular el fitness==Acc del
    %cromosoma en train y test, el que usaremos como fitnes es el AccTest
    carpetaPractica = cd;
    pathOri = [carpetaPractica '\datasets'];
    datasets = dir(pathOri);
    nomDsTr = datasets(3).name;
    nomDsTst = datasets(4).name;
    % leer los ejemplos de cada particion train y test en los .dat
    fTrain = [pathOri '\' nomDsTr ];
    fTest =  [pathOri '\' nomDsTst ];
    [numAtr, nClases, infoAtr, CE, CT, ejClase] = lecturaDatos(fTrain, fTest);
    %GEN(3:3+numAtr)Seleccion Variables segun indique el cromosoma
    varLogic = cromosoma(3:3+numAtr-1);
    varLogic = [varLogic 1];% para coger la clase cuando los montamos
    %GEN(3+numAtr+1:end)Seleccion Ejemplos segun indique el cromosoma
    ejLogic = cromosoma(3+numAtr:end);
    % Montamos CE y CT
    CEAux = CE(logical(ejLogic),logical(varLogic));
    clasesRealesTr = CEAux(:,end);
    CT = CT(:,logical(varLogic));
	% LLAMADA A KNN CON LOS CONJUNTOS MODIFICADOS POR EL GENETICO
    [ CEAux ] = normalizaMaxMin( CEAux );
    [ CT ] = normalizaMaxMin( CT );
    [clasificador,pertenencias] = aprendizaje(CEAux, tipoKNN, KF);        
    %LLAMADA A CLASIFICAR PARA LOS DATOS DE TRAIN HAY QUE PASARLE TODOS LOS
    %DATOS, NO SOLO LOS EJEMPLOS SELECCIONADOS PARA CREAR EL CLASIFICADOR,
    %PERO DA ERROR NOSE PORQUE, PORQUE PARA TEST SI FUNCIONA Y EL TAMAÑO ES
    %DISTINTO!! 
    [matConfusionTr,clasesPredTr,marcasTr ] =  clasificar(clasificador, CEAux, K, tipoKNN, 1,pertenencias,ejLogic); %El 1 indica eejemplos train
    [matConfusionTst,clasesPredTst,marcasTst ] = clasificar(clasificador, CT, K, tipoKNN, 2,pertenencias,ejLogic); %El 2 indica ejemplos tst
    clasesRealesTst = CT(:,end);
    AccTr = rendimiento(matConfusionTr);
    AccTst = rendimiento(matConfusionTst); 
end

