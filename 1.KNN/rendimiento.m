function [acc] = rendimiento( matConfusion)
    [~,nclases] = size(matConfusion);
    % formula real
    %acc = (VP+VN) / (VP + VN + FP + FN);
    %en matlab m�s sencillo y para que sirva siempre
    %eye es la matriz identidad
    acc = sum(sum(matConfusion.*eye(nclases)))/sum(sum(matConfusion));
end

