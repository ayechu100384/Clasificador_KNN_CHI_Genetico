function [ hijo ] = cruceParteBinariaKNN(padre,madre)
    p = padre(3:end);
    m = madre(3:end);    
    dist = (p~=m);
    dist = [0 0 dist];
    hijo = padre;
    for i=1:length(dist)
        if dist(i)==1
            if rand > 0.5
                hijo(i)=padre(i);
            else
                hijo(i)=madre(i);
            end
        end
    end
end

