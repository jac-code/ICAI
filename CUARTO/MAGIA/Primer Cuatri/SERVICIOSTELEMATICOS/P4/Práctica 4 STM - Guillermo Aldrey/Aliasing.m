function MDCTB = Aliasing(MDCT)
%ALIASING Reduce el aliasing introducido por la MDCT.
%
%   MDCTB=ALIASING(MDCT)
%   Retorna en el vector MDCTB de 576 valores el resultado de la reducción del
%   aliasing introducido por el 50% de solapamiento usado al aplicar la MDCT o
%   transformada discreta del coseno modificada.
%
%   El vector MDCT contiene los 576 valores de la transformación obtenida a
%   través de TRANSF_DISCRETA_COSENO.
%
%   Ver también TRANSF_DISCRETA_COSENO.

MDCTB = [];

% Constantes para el cálculo mariposa, proporcionadas por el estándar
% ISO/IEC 11172-3 (vectores c, cs y ca).
% c = [-0.6; -0.535; -0.33; -0.185; -0.095; -0.041; -0.0142; -0.0037];
% cs = 1 ./ sqrt(1+c .^ 2);
% ca = c ./ sqrt(1+c .^ 2);
cs = [0.85749292571254; 0.88174199731771; 0.94962864910273; 0.98331459249179;
   0.99551781606759; 0.99916055817815; 0.99989919524445; 0.99999315507028];
ca = [-0.51449575542753; -0.47173196856497; -0.31337745420390; -0.18191319961098;
   -0.09457419252642; -0.04096558288530; -0.01419856857247; -0.00369997467376];

% Reducción del aliasing o solapamiento a través de 8 cálculos mariposa. La
% reducción se hace en grupos de 18 líneas de frecuencia (a las 16 primeras se
% les hace reducción y a las 2 últimas no), empezando en la muestra 11.
MDCTcs = zeros(8,2);
MDCTca = zeros(8,2);
for i = 11:18:551,
   
   % Las líneas de frecuencia se multiplican por cs y ca.
   MDCTcs = [[MDCT(i+7:-1:i) .* cs] [MDCT(i+8:i+15) .* cs]];
   MDCTca = [[MDCT(i+7:-1:i) .* ca] [MDCT(i+8:i+15) .* ca]];
   
   % El concepto mariposa involucra sumar y restar las líneas de frecuencia en
   % pares, entregando dos nuevas líneas de frecuencia por cada par. En total, se
   % reemplazan 16 líneas de frecuencia (vector MDCTBparcial).
   MDCTBparcial = [MDCTcs(8:-1:1,1)+MDCTca(8:-1:1,2); MDCTcs(:,2)-MDCTca(:,1)];
   
   % Concatenación del resultado anterior con los dos valores de MDCT a los que
   % no se les aplica la reducción del aliasing.
   MDCTB = [MDCTB; MDCTBparcial; MDCT(i+16:i+17)];
   
end

% Los primeros 10 y los últimos 8 valores de MDCT (que no son incluidos en el
% cálculo mariposa) se conservan para MDCTB.
MDCTB = [MDCT(1:10); MDCTB; MDCT(569:576)];