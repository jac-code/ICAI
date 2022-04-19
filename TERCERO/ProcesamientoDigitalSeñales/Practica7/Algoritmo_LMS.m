%% 
% Esta función es una implmentación del algortimo LMS
% Dicho algoritmo es un tipo de algoritmo adaptativo que se basa en 
% la aproximación del gradiente de la superficie de error 

function [yn, en, wn] = Algoritmo_LMS(xn, dn, M, mu)
% Parámetros de entrada:
% 1) xn --> señal con ruido de fondo, correlado con el ruido de dn
% 2) dn --> señal a la que queremos quitarle el ruido de fondo (ruido+voz)
% 3) M --> M + 1 coeficientes del filtro
% 4) mu

% Parámetros de salida:
% 1) yn --> ruido estimado / ruido filtrado por wn
% 2) en --> error del sistema adaptivo 
% 3) wn --> M + 1 coeficientes del filtro adaptivo en cada instante n

% creamos las señales que va devolver nuestra función
yn = zeros(1, length(xn) - M);
en = zeros(1, length(xn));
wn = ones(M+1, 1);

% introducimos M ceros al principio de xn para poder hacer convolución
% completa --> la concolución es nuestro filtrado
xn = [zeros(M, 1); xn];

for i = 1:(length(xn)-M)
    % filtramos xn mediante convolución completa
    yn(i) = wn(:, i).'*xn(i:M+i);
    
    % cálculo del error entre d[n] y y[n]
    en(i) = dn(i)-yn(i);
    
    % cálculo del siguiente coeficiente del filtro
    wn(:, i+1) = wn(:, i) + 2*mu*en(i)*xn(i:(M+i));
end

%filtro adaptativo estimando el gradiente medinate la minimización de su error cuadrático medio
%ya que la señal de audio no varía de manera constante ni conocemos la
%respuesta al impulso del filtro ideal.

% actualiza la señal x con las muestras que va recibiendo en cada instante
% de tiempo y genera una x2 que corresponde a las últimas M+1 muestras
