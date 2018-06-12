clear all;
%% 5NN + Chi (confianza no penalizada, suma)
    k = 5; 
    %ojo umbral 10, mejor 5 repasar
   [matrizResultados,clasesPred5NN,infoDudosos,marcas,clasesReales] = aplicaKNNModificado(0,k,0);
   %Genera reglas chi confianza no penalizada suma
   tipoAg = 1;%suma
   tipoPeso = 0;%no penalizada
   [matrizResultados,prediccionChi] = aplicaReglasDifusas(tipoAg,tipoPeso);

   %Juntamos
   aleatorios = round(rand(length(prediccionChi),1));
   clasesNuevas = clasesPred5NN;
   clasesNuevas(logical(aleatorios(marcas==1))) = prediccionChi(logical(aleatorios(marcas==1)));
   aciertosk5 = sum(clasesNuevas==clasesReales) / length(clasesNuevas);
   a = 5
  
%% 7NN + Chi (confianza no penalizada, suma)
    k = 7; 
   [matrizResultados,clasesPred5NN,infoDudosos,marcas,clasesReales] = aplicaKNNModificado(1,k,0);
   %Genera reglas chi confianza no penalizada suma
   tipoAg = 0;
   tipoPeso = 1;
   [matrizResultados,prediccionChi] = aplicaReglasDifusas(tipoAg,tipoPeso);

   %Juntamos
   aleatorios = round(rand(length(prediccionChi),1));
   clasesNuevas = clasesPred5NN;
   clasesNuevas(logical(aleatorios(marcas==1))) = prediccionChi(logical(aleatorios(marcas==1)));
   aciertosk7 = sum(clasesNuevas==clasesReales) / length(clasesNuevas);
  
   %% 5NN KF=3 + Chi (confianza no penalizada, suma) 
    k = 5; 
    kf = 3;
   [matrizResultados,clasesPred5NN,infoDudosos,marcas,clasesReales] = aplicaKNNModificado(1,k,kf);
   %Genera reglas chi confianza no penalizada suma
   tipoAg = 0;
   tipoPeso = 1;
   [matrizResultados,prediccionChi] = aplicaReglasDifusas(tipoAg,tipoPeso);

   %Juntamos
   aleatorios = round(rand(length(prediccionChi),1));
   clasesNuevas = clasesPred5NN;
   clasesNuevas(logical(aleatorios(marcas==1))) = prediccionChi(logical(aleatorios(marcas==1)));
   aciertosk5KF7 = sum(clasesNuevas==clasesReales) / length(clasesNuevas);
   