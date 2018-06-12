function result = knnTest(dataset,numTest,numTrain,distType,k,voteType,isTrain)
    %Comprueba el knn con un dataset de entrada
    %El tipo de distancia tiene que ser:
        %'eucl' (por defecto)
        %'manh'
    %K el número de vecinos
    %El argumento isTrain indica si se debe ejecutar el algoritmo sobre el
    %conjunto de train o sobre el de test:
        %Si vale 0 se aplica sobre el test
        %Si vale 1 se aplica sobre el de train
    
    %Si lo que queremos es ejecutarlo sobre el conjunto de train
    if isTrain
        %Lo que hacemos es cambiar el de test por el de train
        dataset.test = dataset.training;
    end
    
    %Repetimos la matriz y la giramos de tal forma que nos ahorramos
    %ambos bucles
    repsTst = repmat(dataset.test(:,1:(end-1)),[1 1 numTrain]);
    repsTst = permute(repsTst,[3 2 1]);
    %Cada 'loncha' de esta matriz es todo un ejemplo repetido tantas veces
    %como ejemplos de train hay
    
    repsTrain = repmat(dataset.training(:,1:(end-1)),[1 1 numTest]);
    %Cada 'loncha' de esta matriz es todos los ejemplos
    
    %Al juntar esas dos matrices en 3D, todos los ejemplos se comparan con
    %todos. 
    distances = distance(repsTrain,repsTst,distType);
    
    if isTrain
        infMat = eye(numTest);%Es una matriz de tamaño train x train (distancias)
        infMat(infMat==1)=Inf;
        distances=distances+infMat;
    end
    
    %Ordenamos las distancias
    [sortDist index] = sort(distances,1,'ascend');
    
    %Cogemos los k vecinos más cercanos
    kDistances = sortDist(1:k,:);
    kIndex = index(1:k,:);
    %Las clases para cada índice
    c = dataset.training(:,end);
    kClasses = c(kIndex);
    
    %Si k es 1 da problemas, pero realmente no es necesario votar, es la
    %clase del vecino
    if k==1
        result = kClasses';
    %Si no hacemos la votación
    else
        %Calculamos cuantos ejemplos hay de cada clase
        classesGlobalHist = hist(dataset.training(:,end),dataset.numClasses);

        result = vote(kClasses,dataset.numClasses,kDistances,voteType,classesGlobalHist,numTest);
    end    
end

function dist = distance(train,example,type)
    %Hace la distancia indicada entre el conjunto de entrenamiento y el
    %ejemplo concreto (hecho con repmat antes)
    %Devuelve la distancia como matriz:
        %         tst1 | tst2 | tst3 | ... | tstn |
        %        ---------------------------------
        %train1 |      |      |      | ... |      |
        %        ---------------------------------
        %train2 |      |      |      | ... |      |
        %        ---------------------------------
        %train3 |      |      |      | ... |      |
        %..........................................
        %trainm |      |      |      | ... |      |
        %        ---------------------------------

    %Distancia de Manhattan
    if strcmp(type,'manh')
        d = sum(abs(train-example),2);
    %Euclidea
    else
        d = sqrt(sum((train-example).^2,2));
    end
    
    %Cambiamos las dimensiones
    dist(:,:)=d(:,1,:);
end

function res=vote(classes,numClasses,distances,voteType,classesGlobalHist,numTest)
    %Función que vota. Necesita las clases de los k vecinos
    %clase y las distancias. 
    %El tipo de voto tiene que ser:
        %'simple' para el voto simple (por defecto)
        %'pond' para el voto ponderado
    %También se necesita el recuento de cuántas veces se repite cada clase
    %en el training y el número de ejemplos de Test
    %En res devuelve para cada ejemplo
        
    if(strcmp('pond',voteType))
        %Calculamos los pesos
        w=1./(distances.*distances);
        h=zeros(numClasses,numTest);
        
        for i=1:numClasses
            h(i,:)=sum((classes==i).*w);
        end
        
    else %Básico
        %Una vez que tenemos los vecinos, tenemos que votar. Obtenemos el
        %histograma para cada valor
        h = hist(classes,numClasses);
        %Formato del histograma:
        %          tst1 | tst2 | ... |tstn |
        %         -------------------------
        %clase 1 |      |      | ... |     |
        %...................................
        %clase m |      |      | ... |     |
        %         -------------------------
    end

    winner= max(h);
    
    isMax = h==repmat(winner,numClasses,1);
    
    %Solo se ha cambiado el valor del histograma en las clases que han
    %ganado (en las que son el máximo). Si solo hay una, el resto serán 0
    %por lo que dará el máximo sea cual sea. Si había empate hemos
    %conseguido poner el número de veces que se repite la clase en el test.
    [~, res] = max(repmat(classesGlobalHist',1,numTest).*isMax);
end