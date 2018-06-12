%Clasificación usando las reglas difusas de Chi
%tipoPeso
    % 0, confianza no penalizada
    % 1, confianza penalizada
%tipoAgregacion
    % 0, suma
    % 1, maximo
    for tipoPeso=0:1
        for tipoAg=0:1
            [matrizResultados] = aplicaReglasDifusas(tipoAg,tipoPeso);
        end
    end