% Funcion con ley de compresion LEY A
% Entradas --> señal a ser comprimida
%              parámetro para la Ley A
% Salida --> señal comprimida

function [res] = Bloque_Compresor(entrada, A)

   for j= 1:length(entrada)
        if abs(entrada(j)) < 1/A
            res(j) = sign(entrada(j))*(A*abs(entrada(j))/(1+log(A)));
        else
            res(j) = sign(entrada(j))*((1+log(A * abs(entrada(j))))/(1+log(A)));    
        end
    end
end








