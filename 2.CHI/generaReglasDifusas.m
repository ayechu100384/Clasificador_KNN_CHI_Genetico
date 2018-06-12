function [ reglas ] = generaReglasDifusas(CE,numEt,tipoPeso)
%   variables para realizar pruebas
%     CE = [0 0.8 0.2 0.9 0.1 0 2; 0.7 0.3 0 0 0.7 0.3 1;0 0.6 0.4 0.3 0.7 0 2 ];
%     numEt = 3;
%     tipoPeso = 1;
    [numEj,columnas] = size(CE);
    numAtr = (columnas-1)/numEt;
    atr = zeros(1,numAtr);
    reglas = zeros(1,numAtr+2);% la última columna es el peso de la clase
    for i=1:numEj
        nuevaRegla = zeros(1,numAtr+1);
        pesosNuevaRegla = ones(1,numEj);
     %Nueva regla
        for k=1:numAtr
            [~,atr(k)] = max(CE(i,(numEt*k+1-numEt):(k*numEt)));
        end 
        %adaptamos la regla
        for k=1:numAtr
            atr(:,k) = atr(:,k)+numEt*(k-1);
        end
        %le añadimos la clase a la regla
        nuevaRegla = [atr,CE(i,end)];
      %Pesos nueva regla
        for k=1:numAtr
            pesosNuevaRegla = pesosNuevaRegla .* CE(:,nuevaRegla(k))';
        end
        %añadimos la clase a los pesos
        pesosNuevaRegla = [pesosNuevaRegla' , CE(:,end)]; 
        if tipoPeso ==0%Confianza sin penalizar, por la suma del resto de clases
            pesosMismaClase = pesosNuevaRegla(pesosNuevaRegla(:,2)==nuevaRegla(:,end));
            numerador = sum(pesosMismaClase(:,1));
            denominador = sum(pesosNuevaRegla(:,1));
                RW = numerador/denominador;
        end
        if tipoPeso ==1%Confianza penalizada, por la suma del resto de clases
            pesosMismaClase = pesosNuevaRegla(pesosNuevaRegla(:,2)==nuevaRegla(:,end));
            aux = sum(pesosMismaClase(:,1));
            pesosDistintaClase = pesosNuevaRegla(pesosNuevaRegla(:,2)~=nuevaRegla(:,end));
            
            numerador = sum(pesosDistintaClase(:,1));
            numerador = aux-numerador;
            denominador = sum(pesosNuevaRegla(:,1));
            if denominador == 0
                RW = 0;
            else
                RW = (numerador)/denominador;
            end
        end
        %le añadirmos el peso a la regla
        if RW>0
            nuevaRegla = [nuevaRegla,RW];
            if (ismember(nuevaRegla(1:numAtr),reglas(:,1:numAtr),'rows') ~= 1)%nueva regla distinto antecedente
                reglas = [reglas; nuevaRegla];
            else %si existe una regla con el mismo antecedente
                if (ismember(nuevaRegla(1:numAtr+1),reglas(:,1:numAtr+1),'rows') ~= 1)%distinto consecuente
                    %añadimos la de mayor peso y quitamos la otra
                    [~,posRepetida] = ismember(nuevaRegla(1:numAtr),reglas(:,1:numAtr),'rows');
                    if reglas(posRepetida,end) < nuevaRegla(:,end)
                        reglas = [reglas(1:posRepetida-1,:);reglas(posRepetida+1:end,:)];%quito la repetida
                        reglas = [reglas; nuevaRegla];%añado la nueva
                    end
                end
            end
        end
    end
    %Quitamos la primera fila de reglas, es la inicializacion porque sino
    %da error el ismember
    reglas = reglas(2:end,:);
end

