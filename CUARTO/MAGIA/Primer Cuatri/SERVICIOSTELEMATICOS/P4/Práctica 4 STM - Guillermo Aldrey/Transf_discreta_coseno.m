function MDCT = Transf_discreta_coseno(S,U576,sb,gr)
%TRANSF_DISCRETA_COSENO Calcula la transformada discreta del coseno modificada.
%
%   MDCT=TRANSF_DISCRETA_COSENO(S,U576,SB,GR)
%   Retorna los 18 valores (vector MDCT) correspondientes al resultado de aplicar
%   la transformada discreta del coseno modificada, con 50% de solapamiento,
%   sobre 36 muestras subbanda consecutivas en el tiempo.
%
%   S es la matriz de 1152 muestras subbanda obtenidas con FILTRO_SUBBANDA. La
%   matriz U576 proporciona las últimas 576 muestras subbanda de la matriz S
%   anterior, SB es el número de subbanda a procesar, GR es el gránulo actual,
%   los cuales fueron obtenidos en WAV2MP3.
%
%   Ver también FILTRO_SUBBANDA, WAV2MP3.

% En cada subbanda, los 18 valores de salida del gránulo anterior (almacenados en
% U576) y los 18 valores de salida del gránulo actual se ensamblan en un bloque
% de 36 muestras (vector xp). En caso de que el gránulo sea el segundo, para cada
% subbanda, la matriz S es procesada directamente.
if gr == 1
   xp = [U576(1:18,sb); S(1:18,sb)];
else
   xp = S(1:36,sb);
end

% Calcula el vector z de 36 valores para el tipo de bloque NORMAL.
z = xp' .* sin((pi/36)*(0.5:35.5));

% Calcula el vector MDCT de 18 valores para bloques largos.
MDCT = zeros(18,1);
fMDCT = pi/72*(19:2:89);
for i = 1:18,
   MDCT(i) = sum(z.*cos((2*i-1)*fMDCT));
end