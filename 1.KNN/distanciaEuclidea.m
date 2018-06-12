function [ distancia ] = distanciaEuclidea( a, b)
    distancia = sqrt(sum(a-b).^2);
end

