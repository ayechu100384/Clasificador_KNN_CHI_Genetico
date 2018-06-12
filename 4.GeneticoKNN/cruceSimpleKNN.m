function [ hijo ] = cruceSimpleKNN(padre,madre)
    numAtr=13; % SE el numero de var del ds original (para hacer los cromsm) 
    %El hijo igual que el padre excepto la partde de SV de la madre
    hijo=padre;
    %SV de madre
    hijo(3:3+numAtr-1)= madre(3:3+numAtr-1);
end

