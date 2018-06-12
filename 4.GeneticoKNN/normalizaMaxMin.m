function [ cjtoNorm ] = normalizaMaxMin( cjto )
%     X = cjto(:,1:end-1);
%     vMax = max(X);
%     vMin = min(X);
%     [m,~]=size(cjto);
%     for i=1:m
%         X(i,:) = (X(i,:)-vMin) / (vMax-vMin);
%     end
%     cjto(:,1:end-1)=X;
%     cjtoNorm=cjto;
%     
    %Es lo mismo?? DUDA Josean
    X = cjto(:,1:end-1);
    vMax = max(X);
    vMin = min(X);
    vDen = vMax-vMin;
    X = bsxfun(@minus,X,vMin);
    X = bsxfun(@rdivide,X,vDen);
    cjto(:,1:end-1)=X;
    cjtoNorm=cjto;
end

