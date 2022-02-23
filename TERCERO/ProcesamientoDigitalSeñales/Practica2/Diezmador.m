%%  Función: Diezmador
%
%  Descripción: Aplica un factor de diezmado a una señal muestreada.
%
%  Argumentos de entrada:
%  - x_n: señal de entrada.
%  - M: factor de diezmado.
%  - t_xn: vector de tiempos de la señal x[n]
%
%  Argumentos de y_n:
%  - y_n: señal de y_n, diezmada.
%  - t_yn: nuevo vector de tiempos para x_n[n]

function [y_n, t_yn] = Diezmador(x_n, t_xn, M)
    aux =(t_xn(2)-t_xn(1))*M;
    t_yn = t_xn(1):aux:t_xn(end);
    
    y_n = zeros(1, floor(length(x_n)/M));
    y_n = x_n(1:M:end);
end

