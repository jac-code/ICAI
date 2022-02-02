function [respuesta] = Compresor(x,A)
    %respuesta = zeros(length(x));
   for i= 1:length(x)
        if abs(x(i)) < 1/A
            respuesta(i) = sign(x(i))*(A*abs(x(i))/(1+log(A)));
        else
            respuesta(i) = sign(x(i))*((1+log(A * abs(x(i))))/(1+log(A)));    
        end
    end
end








