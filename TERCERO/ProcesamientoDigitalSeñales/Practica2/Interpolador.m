%%  Función: Interpolador
%
%  Descripción: Aplica un factor de interpolado a una señal muestreada.
%
%  Argumentos de entrada:
%  - x_n: señal de entrada.
%  - L: factor de interpolado.
%  - t_xn: vector de tiempos de la señal x[n]
%
%  Argumentos de y_n:
%  - y_n: señal de salida, interpolada.
%  - t_yn: nuevo vector de tiempos para y[n]

function [y_n, t_yn] = Interpolador(x_n, t_xn, L)
    y_n = zeros(1, length(x_n)*L);
    y_n(1:L:end) = x_n;
    
    aux =(t_xn(2)-t_xn(1))/L;
   
    t_yn = t_xn(1):aux:(t_xn(end) + aux);
end
