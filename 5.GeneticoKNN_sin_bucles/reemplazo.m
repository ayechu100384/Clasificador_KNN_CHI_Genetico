function [ nuevaGeneracion ] = reemplazo( poblacionActual,fitActual, susHijos,tipoReemplazo)
    tamPob = size(poblacionActual,1);
    nuevaGeneracion =[];
    % Reemplazo brecha generacional
    %El fitnes actual lo conocemos, el de los hijos no
    if tipoReemplazo==1 % brecha
        for i=1:tamPob
            [fitHijos(i) , ~ ] = runKNNsinBucles( susHijos(i,:) );
            runKNNsinBucles
        end
        [~,rankP] = sort(fitActual,'descend');
        [~,rankH] = sort(fitHijos,'descend');
        lambda = 0.8; % BRECHA GENERACIONAL: el 80% de la `pobActual se reemplaza con los mejores hijos
        numPadresSv = round((1-lambda)*tamPob) ;
        numHijosSv = tamPob-numPadresSv;
        nuevaGeneracion = poblacionActual(rankP(1:numPadresSv),:);
        nuevaGeneracion = [nuevaGeneracion ; susHijos(rankH(1:numHijosSv),:) ];
    end
    if tipoReemplazo==2 % generacional
        nuevaGeneracion = susHijos;
    end
     if tipoReemplazo==3 % elite
        for i=1:tamPob
            [fitHijos(i) , ~] = runKNNsinBucles( susHijos(i,:) );
        end
        pobTotal = [poblacionActual; susHijos];
        fitTotal = [fitActual fitHijos];
        [~,rank] = sort(fitTotal,'descend');
        nuevaGeneracion = pobTotal(rank(1:tamPob),:);
     end
	
end

