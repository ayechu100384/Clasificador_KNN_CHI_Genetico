function [sal] = stringRep(a)
    
    sal = '';
    
    for i = 1:length(a)
       incremento = (1-0) / (2^30-1);
       if incremento == 0
           n = uint32(0);
       else
            n = uint32(a(i)/incremento + 0.5);
       end
       tmpstring = Itoc(n);
       aux = Gray(tmpstring);
       sal = strcat(sal, aux);
    end
end

function [sal] = Itoc(n)
    
    aux = dec2bin(n);
    l = 30;
    
    if length(aux) > 30
        aux(31:end) = [];
    end
    
    for i = 1:l-length(aux)
       sal(i) = num2str(0);
    end
    j = 1;
    for i = (l-length(aux)+1):l
       sal(i) = aux(j);
       j = j+1;
    end
   
end

function [sal] = Gray(a)
    last = '0';
    for i = 1:length(a)
        if strcmp(last, a(i))
            sal(i) = '0';
        else
            sal(i) = '1';
        end
        last = a(i);
    end
    
end