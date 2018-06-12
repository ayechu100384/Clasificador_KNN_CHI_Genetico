%% ALGORITMO GENETICO: BUSQUEDA MEJOR KNN usando KNN sin bucles
clear;clc;
%% ===INICIALIZACION poblacion y fitness inicial===
rangoKF=10;
rangoK=10;
fprintf('Creando poblacion y fitness inicial\n');
tamPob=20;
numVarTotales=13;
numEjTotalesTrain=237;
[ poblacion ] = creaPoblacion( tamPob,numVarTotales,numEjTotalesTrain,rangoKF,rangoK );
% load('sol.mat'); % incluimos un cromosoma con un buen fitnesss en la pob
% inicial
poblacion(1,:)= CromSolucion;
for i=1:tamPob
    [fitnessTra(i) , fitnessTst(i)] = runKNNsinBucles( poblacion(i,:) );
end
%% ===PARAMETROS GENETICO===
[tamPob,tamCrom]=size(poblacion);
nGeneraciones=15;
generActual = 1;
probMutar = 0.5;
tipoMut=1;
fit_hist_Test = zeros(nGeneraciones,tamPob);
fit_hist_Train = zeros(nGeneraciones,tamPob);
pob_hist = zeros(tamPob,tamCrom,nGeneraciones);
fit_hist_Test(generActual,:)=fitnessTst;
fit_hist_Train(generActual,:)=fitnessTra;
pob_hist(:,:,generActual)=poblacion;
tic;
while generActual <= nGeneraciones 
    fprintf('Generacion %d: AccTrain:%d | AccTest:%d \n',generActual,max(fit_hist_Train(generActual,:))*100,max(fit_hist_Test(generActual,:))*100);
    %a) SELECCION PROGENITORES
    tPadres = seleccionProgenitores( poblacion,fitnessTra );
    %b) CRUCE POBLACION
    hijos = crucePoblacion( poblacion, tPadres,2 ); %1 cruceSimple / 2cruceBinarios
    %c) MUTACION
    [ hijosMutados ] = mutacionPoblacion( hijos, probMutar, rangoKF,rangoK );
    %d) REEMPLAZO
    poblacion = reemplazo( poblacion,fitnessTra, hijosMutados,3);%1brecha / 2generacional / 3elite
    % PREPARAR SIGUIENTE GENERACION
    generActual = generActual +1; 
    %Fitnes para la siguiente generacion
    if generActual~=nGeneraciones+1
        for i=1:tamPob
            [fitnessTra(i) , fitnessTst(i)] = runKNNsinBucles( poblacion(i,:) );
        end
        fit_hist_Test(generActual,:)=fitnessTst;
        fit_hist_Train(generActual,:)=fitnessTra; 
        pob_hist(:,:,generActual)=poblacion;
    end
end
toc;
% Mostrar grafica evolucions
figure;
plot(1:nGeneraciones,max(fit_hist_Test,[],2)*100);
hold on;
plot(1:nGeneraciones,mean(fit_hist_Test,2)*100);
plot(1:nGeneraciones,min(fit_hist_Test,[],2)*100);
xlabel('Genearación');
ylabel('Fitness test');
legend('max','mean','min');
title('EVOLUCION TEST');
figure;
plot(1:nGeneraciones,max(fit_hist_Train,[],2)*100);
hold on;
plot(1:nGeneraciones,mean(fit_hist_Train,2)*100);
plot(1:nGeneraciones,min(fit_hist_Train,[],2)*100);
xlabel('Genearación');
ylabel('Fitness train');
legend('max','mean','min');
title('EVOLUCION TRAIN');
% Mostrar resultados finales
% Obtener el mejor cromosoma de todo el algoritmo en train
mejoresFit = max(fit_hist_Test,[],2);
[~,iRankGeneraciones]= sort(mejoresFit,'descend');
iMejorGeneracion = iRankGeneraciones(1);
[~ , iMejorCrom] = max(fit_hist_Test(iMejorGeneracion,:));
CromSolucion = pob_hist(iMejorCrom,:,iMejorGeneracion); 
% fprintf('SOLUCION \n');
% for i=1: tamPob
%     fprintf('(%s) coste=%d\n',num2str(poblacion(rank(i),:)),1./f(rank(i)));
% end