function [ trainNorm,testNorm ] = normalizar( train,test,infoAtr )
    [fil,col] = size(train);
    trainNorm = zeros(fil,col);
    for i=1:col-1
        trainNorm(:,i) = (train(:,i)-infoAtr(i,1)) / (infoAtr(i,2)-infoAtr(i,1));
    end
    trainNorm(:,col) = train(:,col);
    
    [fil,col] = size(test);
    testNorm = zeros(fil,col);
    for i=1:col-1
        testNorm(:,i) = (test(:,i)-infoAtr(i,1)) / (infoAtr(i,2)-infoAtr(i,1));
    end
    testNorm(:,col) = test(:,col);
end

