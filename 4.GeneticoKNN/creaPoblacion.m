function [ polbacion ] = creaPoblacion( tamPob,numVar,numEj,rangoKF,rangoK )
    %Para cada elemento de la poblacion
    %PRIMER GEN: rangoKF[0a9], si es 0-->KNNclasico
    primerosGenes=randi(rangoKF,tamPob,1)-1;
    %SEGUNDO GEN: valor de K[1a10]
    segundosGenes=randi(rangoK,tamPob,1);
    %13 GENES: Seleccion Variables
    genesSV = round(rand(tamPob,numVar));
    %tamPob GENES: Seleccion Instancias
    genesSI=round(rand(tamPob,numEj));
    for i=1: tamPob
        [ genesSI ] = validacionEjemplosCrom( genesSI );
    end
    %Montamos todos cromosomas 
    polbacion = [primerosGenes segundosGenes genesSV genesSI];   
end

