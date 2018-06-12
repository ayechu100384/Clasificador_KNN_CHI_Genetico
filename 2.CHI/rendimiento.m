function [acc] = rendimiento( matConfusion)
    [~,nclases] = size(matConfusion);
    acc = sum(sum(matConfusion.*eye(nclases)))/sum(sum(matConfusion));
end

