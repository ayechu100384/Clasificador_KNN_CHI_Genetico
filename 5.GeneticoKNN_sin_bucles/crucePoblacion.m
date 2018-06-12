function [ hijos ] = crucePoblacion( poblacion, tPadres, tipoCruce)
    hijos = zeros(size(poblacion));
    tPadres = reshape(tPadres,length(tPadres)/2,2);
    [nPadres,~] = size(tPadres);
    for i=1:nPadres
        padre = poblacion(tPadres(i,1),:);
        madre = poblacion(tPadres(i,2),:);
        if tipoCruce==1
            h1 = cruceSimpleKNN(padre,madre);
            h2 = cruceSimpleKNN(madre,padre);
        end
        if tipoCruce==2
            h1 = cruceParteBinariaKNN(padre,madre);
            h2 = cruceParteBinariaKNN(madre,padre);
        end
        hijos((i*2)-1,:) = h1;
        hijos((i*2),:) = h2;
    end
end

