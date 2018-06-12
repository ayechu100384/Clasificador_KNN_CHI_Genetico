function [ cjtoNorm ] = normalizarMedia( cjto )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes herevMedias = mean(X,1);
    X = cjto(:,1:end-1);
    vMedias = mean(X,1);
    vSigmas = std(X,1);
    X = bsxfun(@minus,X,vMedias);
    X = bsxfun(@rdivide,X,vSigmas);
    cjto(:,1:end-1)=X;
    cjtoNorm=cjto;
end

