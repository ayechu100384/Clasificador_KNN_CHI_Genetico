function [accuracy] = rendimiento(matConfusion)
    [~,nclases]=size(matConfusion);
    accuracy = sum(sum(matConfusion.*eye(nclases))) / sum(sum(matConfusion));
end

