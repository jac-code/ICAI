% Funcion con ley de expansion LEY A
% Entrada --> señal a ser expandida
%             parámetro para la Ley A
% Salida --> señal expandida

function [res] = Bloque_Expansor(entrada, A)

   for j= 1:length(entrada)
        if abs(entrada(j)) < 1/(1+log(A))
            res(j) = sign(entrada(j))*((1+log(A))*abs(entrada(j)))/A;
        else
            res(j) = sign(entrada(j))*(exp((abs(entrada(j))*(1+log(A)))-1))/A; 
        end
    end
end