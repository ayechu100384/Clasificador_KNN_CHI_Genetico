function [ parejasProgenitores ] = seleccionProgenitores( poblacion,fitnessPob )
    %METODO DEL TORNEO con K participantes y K= tamPob/2
    [tamPob,~]=size(poblacion);
    K = round(tamPob/2);
    for i=1:tamPob
        iParticip = randi(tamPob,1,K);
        [~,ranking] = sort(fitnessPob(iParticip),'descend');
        parejasProgenitores(i)=ranking(1);
    end
    %parejasProgentores es un vector de tamPob elementos y cada pareja
    %creará 2 descendientes en el cruce
end

