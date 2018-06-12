function [ crom ] = mutacion( crom, probMutar,rangoKF,rangoK )
   if probMutar>rand
     for i=length(crom)
        crom(1) = randi(rangoKF,1,1)-1;
        crom(2) = randi(rangoKF,1,1);
        crom(3:end) = round(rand(1,length(crom)-2));
         [ crom(3:end) ] = validacionEjemplosCrom( crom(3:end) );
     end
   end
end

