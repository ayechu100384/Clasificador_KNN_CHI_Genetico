%Llamamos a aplica KNN con todas las variaciones posibles de
%k = 1,3,5,7
%KF = 1,3,5,7
matrizResultados = [];
for k=1:2:7
    %[matrizResultados] = aplicaKNN(tipoKNN, k, KF )
    %tipoKNN = 0 KNNclásico, tipoKNN = 1 KNNdifuso
    [aux] = aplicaKNN(0,k,0);
    matrizResultados = [matrizResultados;aux];
    for KF=1:2:7
        [aux] = aplicaKNN(1,k,KF);
        matrizResultados = [matrizResultados;aux];
    end
end
%xlswrite('trabajoKNN.xlsx',matrizResultados,'hoja1','B2');