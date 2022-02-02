% h = srrc_filter(beta, span, sps, forma)
%
% Brief: Función que obtiene la respuesta al impulso de un filtro en coseno alzado
% o en raiz cuadrada de coseno alzado.
%
% Author: Carlos García de la Cueva
% Rev: 1.0
% Date: 17/04/2021
%
% Parámetros de entrada:
%   - beta      -> Factor de roll-off
%   - span      -> Longitud del filtro en símbolos
%   - sps       -> Muestras por símbolo
%   - shape     -> "normal" ó "sqrt"
%
% Parámetros de salida:
%   - h         -> Respuesta al impulso de filtro


function h = srrc_filter(beta, span, sps, shape)
    
    %----------------------------------------------------------------------
    % Control de los parámetros de entrada de la función
    if nargin<3
        error('!El número de argumentos de entrada es insuficiente!');
    elseif nargin == 3
        shape = "sqrt";
    end
    
    % Control del parámetro BETA
    if ~isnumeric(beta)
        error('¡El valor introducido de BETA debe ser de tipo numérico!');
    else
        if beta<0 || beta>1
            error('¡El valor de BETA debe cumplir: 0<=BETA<=1!');
        end
    end
    
    % Control del parámetro SPAN
    if ~isnumeric(span) || (span-floor(span))>0
        error('¡El valor introducido de SPAN debe ser de tipo entero!');
    else
        if span<=0
            error('¡El valor de SPAN debe cumplir: SPAN > 0!');
        end
    end
    
    % Control del parámetro SPS (TODO)
    if ~isnumeric(sps) || (sps-floor(sps))>0
        error('¡El valor introducido de SPS debe ser de tipo entero!');
    else
        if sps<=0
            error('¡El valor de SPS debe cumplir: SPS > 0!');
        end
    end
    
    % Control del parámetro SHAPE
    if shape ~= "normal" && shape ~= "sqrt"
        error('¡El parámetro SHAPE debe corresponderse con alguno de los siguientes valores!: "sqrt" ó "normal"');
    end
    
    if mod(span*sps,2) == 0
        n = (0:(span*sps)) - (span*sps)/2;
    else
        error('¡El producto de SPS y SPAN debe ser un número par!'); 
    end
    %----------------------------------------------------------------------
    
    % Se inicializa la respuesta al impulso del filtro
    h = zeros(1,length(n));
    
    % Se calculan los coeficientes en función del parámetro SHAPE:
    % - SHAPE = "sqrt" Raiz Cuadrada de Coseno Alzado
    % - SHAPE = "normal" Coseno Alzado (sólo válido para simulación)
    if shape == "sqrt"
        h(n==0) = (1/sqrt(sps))*(1-beta+4*beta/pi);
        h(abs(n)==(sps/(4*beta))) = (beta/(sqrt(2*sps)))*((1+2/pi)*sin(pi/(4*beta))+(1-2/pi)*cos(pi/(4*beta)));
        n_aux = n((n~=0)&(abs(n)~=(sps/(4*beta))));
        h((n~=0)&(abs(n)~=(sps/(4*beta)))) = (1/sqrt(sps))*(sin(pi*n_aux*(1-beta)/sps)+4*beta*n_aux.*cos(pi*n_aux*(1+beta)/sps)/sps)./(pi*n_aux.*(1-(4*beta*n_aux/sps).^2)/sps);
    elseif shape == "normal"
        h(n==0) = 1/sps;
        h(abs(n)==(sps/(2*beta))) = (1/sps)*(sin(pi/(2*beta))/(pi/(2*beta)))*(pi/4);
        n_aux = n((n~=0)&(abs(n)~=(sps/(2*beta))));
        h((n~=0)&(abs(n)~=(sps/(2*beta)))) = (1/sps)*(sin(pi*n_aux/sps)./(pi*n_aux/sps)).*(cos(pi*beta*n_aux/sps)./(1-(2*beta*n_aux/sps).^2));
    end
    
    % Se fuerza a que la energía de símbolo sea 1
    h = h/sqrt(sum(abs(h).^2));
end