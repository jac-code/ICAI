function Datos_principales(IX,IS,SHT,slen1,slen2,big_values,table_select,rlb,...
   fe,ff,tabla_0,tabla_1,count1,count1table_select,main_data_begin,padding_bit,mdt)
%DATOS_PRINCIPALES Escritura de los datos principales.
%
%   DATOS_PRINCIPALES(IX,IS,SHT,SLEN1,SLEN2,BIG_VALUES,TABLE_SELECT,RLB,FE,FF,...
%      TABLA_O,TABLA_1,COUNT1,COUNT1TABLE_SELECT,MAIN_DATA_BEGIN,PADDING_BIT,MDT)
%
%   Realiza la escritura de los datos principales.
%
%   IX es el vector de valores espectrales cuantizados (sin tener en cuenta
%   el signo de XR), obtenido con CICLO_INTERNO. IS es el vector de valores
%   espectrales cuantizados (teniendo en cuenta el signo de XR), obtenido
%   con CICLO_INTERNO. SHT es la matriz que contiene las 3 tablas de Huffman
%   seleccionadas para codificar las 3 subregiones de big_values, obtenida
%   con CICLO_INTERNO. SLEN1 es la cantidad de bits que consumen los factores
%   de escala para las primeras 11 bandas del factor de escala, y slen2 es la
%   cantidad de bits que consumen los factores de escala para las últimas
%   10 bandas del factor de escala, ambos obtenidos en WAV2MP3. BIG_VALUES es
%   la cantidad de valores espectrales, contados por pares, ubicados en las
%   bajas frecuencias, obtenido con CICLO_INTERNO. TABLE_SELECT es el vector
%   que incluye el número de las tablas de Huffman usadas para codificar region0,
%   region1 y region2, obtenido con CICLO_INTERNO. RLB indica la cantidad de
%   bits usados para codificar el valor adicional en cada una de las 3 subregiones
%   en que se divide big_values (el valor adicional es necesario si el valor
%   máximo de la subregión es mayor que 14), obtenida con CICLO_INTERNO. El
%   vector FE indica el principio de cada una de las 3 subregiones en que se
%   divide big_values; y el vector FF indica el final de cada una de las
%   3 subregiones en que se divide big_values, ambos obtenidos con CICLO_INTERNO.
%   TABLA_0 es la tabla A; y TABLA_1 es la tabla B, usadas para codificar los
%   cuádruplos count1, y ambas obtenidas en WAV2MP3. COUNT1 es la cantidad de
%   cuádruplos incluidos en la región count1 (región intermedia del vector IX),
%   obtenida con CICLO_INTERNO. COUNT1TABLE_SELECT indica la tabla de Huffman
%   escogida (tabla A o tabla B) para codificar los cuádruplos de valores
%   pertenecientes a la región count1, obtenida con CICLO_INTERNO.
%   MAIN_DATA_BEGIN es el puntero que indica el comienzo de la información de
%   audio (main_data) de cada trama, obtenido en WAV2MP3. PADDING_BIT es la
%   bandera que indica si la trama usa padding_bit, obtenida en WAV2MP3. MDT es
%   la cantidad máxima de bits para main_data, por trama, obtenida en WAV2MP3.
%
%   Ver también WAV2MP3, CICLO INTERNO.

global scalefac_l bin_str

% Carga los valores máximos de las 30 tablas de Huffman usadas para
% big_values, e inicializa la cadena binaria de audio.
maxth = [1 2 3 3 0 4 4 6 6 6 8 8 8 ones(1,19)*16];
aud_str = '';

for gr = 1:2,
   
   % Escribe los factores de escala en la cadena binaria de audio.
   if slen1(gr) ~= 0
      for sfb = 1:11,
         aud_str = [aud_str dec2bin(scalefac_l(sfb,gr),slen1(gr))];
      end
   end
   if slen2(gr) ~= 0
      for sfb = 12:21,
         aud_str = [aud_str dec2bin(scalefac_l(sfb,gr),slen2(gr))];
      end
   end
   
   % Escribe los códigos de Huffman para los pares big_values en la cadena
   % binaria de audio.
   for region = 1:3,
      if table_select(gr,region) ~= 0
         if table_select(gr,region) > 15
            
            %Se usan las tablas de Huffman que incluyen linbits (linbits>0).
            for i = fe(gr,region):2:ff(gr,region),
               x = IX(i,gr);
               y = IX(i+1,gr);
               if x > 14
                  linbitsx = x-15;
                  x = 15;
               end
               if y > 14
                  linbitsy = y-15;
                  y = 15;
               end
               
               % El campo hcod([x][y]) se extrae de la tabla SHT, con ayuda del
               % campo table_select, y se escribe en la cadena binaria de audio
               % empezando por el bit más a la izquierda; la cantidad de bits es
               % hlen([x][y]).
               aud_str = [aud_str dec2bin(SHT(maxth(table_select(gr,region)+1)*...
                     x+y+1,region*2,gr),SHT(maxth(table_select...
                     (gr,region)+1)*x+y+1,region*2-1,gr))];
               
               % Escribe linbitsx en la cadena binaria de audio; la cantidad
               % de bits es linbits (vector rlb).
               if x > 14
                  aud_str = [aud_str dec2bin(linbitsx,rlb(gr,region))];
               end
               
               % Escribe signx en la cadena binaria de audio. Se escribe '0'
               % si es positivo, y '1' si es negativo. La cantidad de bits es 1.
               if IS(i,gr) > 0
                  aud_str = [aud_str dec2bin(0,1)];
               elseif IS(i,gr) < 0
                  aud_str = [aud_str dec2bin(1,1)];
               end
               
               % Escribe linbitsy en la cadena binaria de audio; la cantidad
               % de bits es linbits (vector rlb).
               if y > 14
                  aud_str = [aud_str dec2bin(linbitsy,rlb(gr,region))];
               end
               
               % Escribe signy en la cadena binaria de audio. Se escribe '0' si es
               % positivo, y '1' si es negativo. La cantidad de bits es 1.
               if IS(i+1,gr) > 0
                  aud_str = [aud_str dec2bin(0,1)];
               elseif IS(i+1,gr) < 0
                  aud_str = [aud_str dec2bin(1,1)];
               end
            end
         else
            % Se usan las tablas de Huffman que no incluyen linbits (linbits=0).
            for i = fe(gr,region):2:ff(gr,region),
               x = IX(i,gr);
               y = IX(i+1,gr);
               
               % El campo hcod([x][y]) se extrae de la tabla SHT, con ayuda del
               % campo table_select, y se escribe en la cadena binaria de audio
               % empezando por el bit más a la izquierda, la cantidad de bits es
               % hlen([x][y]).
               aud_str = [aud_str dec2bin(SHT(maxth(table_select(gr,region)+1)*...
                     x+y+1,region*2,gr),SHT(maxth(table_select...
                     (gr,region)+1)*x+y+1,region*2-1,gr))];
               
               % Escribe signx en la cadena binaria de audio. Se escribe '0'
               % si es positivo, y '1' si es negativo. La cantidad de bits es 1.
               if IS(i,gr) > 0
                  aud_str = [aud_str dec2bin(0,1)];
               elseif IS(i,gr) < 0
                  aud_str = [aud_str dec2bin(1,1)];
               end
               
               % Escribe signy en la cadena binaria de audio. Se escribe '0'
               % si es positivo, y '1' si es negativo. La cantidad de bits es 1.
               if IS(i+1,gr) > 0
                  aud_str = [aud_str dec2bin(0,1)];
               elseif IS(i+1,gr) < 0
                  aud_str = [aud_str dec2bin(1,1)];
               end
            end
            
         end
      end
   end
   
   % Escribe los códigos de Huffman para los cuádruplos count1 en la
   % cadena binaria de audio.
   for k = big_values(gr)*2+1:4:big_values(gr)*2+count1(gr)*4,
      if count1table_select(gr) == 0
         % Escribe hcod([v][w][x][y]) en la cadena binaria de audio, usando los
         % datos de tabla_0 (tabla A), empezando por el bit más a la izquierda,
         % la cantidad de bits es hlen([v][w][x][y]).
         aud_str = [aud_str dec2bin(tabla_0(2,8*IX(k,gr)+4*IX(k+1,gr)+2*IX(k+2,gr)+...
               IX(k+3,gr)+1),tabla_0(1,8*IX(k,gr)+4*IX(k+1,gr)+2*IX(k+2,gr)+...
               IX(k+3,gr)+1))];
      else
         % Escribe hcod([v][w][x][y]) en la cadena binaria de audio, usando
         % los datos de tabla_1 (tabla B), empezando por el bit más a la
         % izquierda, la cantidad de bits es 4.
         aud_str = [aud_str dec2bin(tabla_1(2,8*IX(k,gr)+4*IX(k+1,gr)+2*IX(k+2,gr)+...
               IX(k+3,gr)+1),4)];
      end
      
      % Se escribe los bits de signo en la cadena binaria de audio. Se escribe
      % '0' si es positivo, y '1' si es negativo. La cantidad de bits es 1.
      if IS(k,gr) > 0
         aud_str = [aud_str dec2bin(0,1)];
      elseif IS(k,gr) < 0
         aud_str = [aud_str dec2bin(1,1)];
      end
      if IS(k+1,gr) > 0
         aud_str = [aud_str dec2bin(0,1)];
      elseif IS(k+1,gr) < 0
         aud_str = [aud_str dec2bin(1,1)];
      end
      if IS(k+2,gr) > 0
         aud_str = [aud_str dec2bin(0,1)];
      elseif IS(k+2,gr) < 0
         aud_str = [aud_str dec2bin(1,1)];
      end
      if IS(k+3,gr) > 0
         aud_str = [aud_str dec2bin(0,1)];
      elseif IS(k+3,gr) < 0
         aud_str = [aud_str dec2bin(1,1)];
      end
      
   end
end

% Escribe un byte adicional en la cadena binaria de audio, para ajustar la tasa
% de bits promedio.
if padding_bit == 1
   aud_str = [aud_str dec2bin(0,8)];
end

% Calcula las longitudes de las cadenas binarias (aud_str y bin_str).
largo = length(aud_str);
LBS = length(bin_str);
mdbx8 = main_data_begin*8;

% Une la cadena binaria de audio (aud_str) con la cadena binaria (bin_str),
% de acuerdo con los valores de main_data_begin y bit_reservoir, y teniendo en
% cuenta las longitudes de ambas cadenas.
if main_data_begin == 0
   % Todos los datos de audio (vector aud_str) se escriben en la trama actual.
   % Si aud_str no consume todos los bits disponibles para el audio, entonces
   % una parte de la trama actual se deja como bit_reservoir para la siguiente
   % trama.
   bin_str = [bin_str aud_str dec2bin(0,mdt+padding_bit*8-largo)];
else
   if mdbx8 <= largo
      % Los datos de audio (vector aud_str) se escriben entre dos tramas: la 
      % trama actual y la anterior. En el caso de que aud_str no consuma todos
      % los bits que habían disponibles, entonces una parte de la trama actual
      % se deja como bit_reservoir para la siguiente trama.
      bin_str(LBS-168-mdbx8+1:LBS-168) = aud_str(1:mdbx8);
      bin_str = [bin_str aud_str(mdbx8+1:largo) dec2bin(0,mdt+padding_bit*8-largo+mdbx8)];
   else
      % Todos los datos de audio (vector aud_str) se escriben en la trama anterior.
      % Si aud_str consume menos bits de los que había en la trama anterior como
      % bit_reservoir, entonces ese fragmento de la trama anterior que no se usó
      % y toda la trama actual se dejan como bit_reservoir para la siguiente trama.
      % NOTA: Debido a que para esta implementación los datos principales se reparten
      % apenas entre 2 tramas, entonces el fragmento de la trama anterior no será
      % sobreescrito y quedará como bits de relleno (stuffing_bits).
      bin_str(LBS-168-mdbx8+1:LBS-168-mdbx8+largo) = aud_str;
      bin_str = [bin_str dec2bin(0,mdt+padding_bit*8)];
   end
end