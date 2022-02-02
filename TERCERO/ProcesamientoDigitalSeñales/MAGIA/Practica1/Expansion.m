function [respuesta] = Expansion(x,A)
   %respuesta = zeros(length(x));
   for i= 1:length(x)
        if abs(x(i)) < 1/(1+log(A))
            respuesta(i) = sign(x(i))*((1+log(A))*abs(x(i)))/A;
        else
            respuesta(i) = sign(x(i))*(exp((abs(x(i))*(1+log(A)))-1))/A; 
        end
    end
end