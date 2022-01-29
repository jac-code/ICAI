function Info_secundaria(main_data_begin,part2_3_length,big_values,...
   global_gain,scalefac_compress,table_select,region0_count,region1_count,...
   preflag,scalefac_scale,count1table_select)

%INFO_SECUNDARIA Escritura de la información secundaria.
%
%   INFO_SECUNDARIA(MAIN_DATA_BEGIN,PART2_3_LENGTH,BIG_VALUES,...
%      GLOBAL_GAIN,SCALEFAC_COMPRESS,TABLE_SELECT,REGION0_COUNT,REGION1_COUNT,...
%      PREFLAG,SCALEFAC_SCALE,COUNT1TABLE_SELECT)
%
%   Realiza la escritura de la información secundaria para cada trama del MP3.
%
%   MAIN_DATA_BEGIN es el puntero que indica el comienzo de la información de
%   audio (main_data) de cada trama, obtenido en WAV2MP3. PART2_3_LENGTH es la
%   cantidad de bits usados para codificar los valores cuantizados, obtenido
%   en WAV2MP3. BIG_VALUES es la cantidad de valores espectrales, contados por
%   pares, ubicados en las bajas frecuencias, obtenido con CICLO_INTERNO.
%   GLOBAL_GAIN es la información del intervalo de cuantización, obtenida en
%   WAV2MP3. SCALEFAC_COMPRESS es un índice a una tabla que proporciona la
%   cantidad de bits que consume la codificación de los factores de escala,
%   obtenido en WAV2MP3. TABLE_SELECT es el vector que incluye el número de las
%   tablas de Huffman usadas para codificar region0, region1 y region2, obtenido
%   con CICLO_INTERNO. REGION0_COUNT es la cantidad de bandas del factor de
%   escala (disminuidas en 1) incluidas en region0, obtenida con CICLO_INTERNO.
%   REGION1_COUNT es la cantidad de bandas del factor de escala (disminuidas en 1)
%   incluidas en region1, obtenida con CICLO_INTERNO. PREFLAG es la bandera que
%   indica el uso de la opción de preénfasis, obtenida con CICLO_EXTERNO.
%   SCALEFAC_SCALE es el escalamiento para los factores de escala, obtenido en
%   WAV2MP3. COUNT1TABLE_SELECT indica la tabla de Huffman escogida para codificar
%   los cuádruplos de valores pertenecientes a la región count1, obtenida con
%   CICLO_INTERNO.
%
%   Ver también WAV2MP3, CICLO INTERNO, CICLO EXTERNO.

global bin_str

% Inicialización de variables.
private_bits = 0; % 5 bits que no se usan. Se ponen en '0'.
scfsi = 0; % Los factores de escala se transmiten para cada gránulo.
window_switching_flag = 0; % Sólo se usan bloques largos.

% Escritura de la información secundaria en la cadena binaria.
bin_str = [bin_str dec2bin(main_data_begin,9)];
bin_str = [bin_str dec2bin(private_bits,5)];
bin_str = [bin_str dec2bin(scfsi,4)];
for gr = 1:2,
   bin_str = [bin_str dec2bin(part2_3_length(gr),12)];
   bin_str = [bin_str dec2bin(big_values(gr),9)];
   bin_str = [bin_str dec2bin(global_gain(gr),8)];
   bin_str = [bin_str dec2bin(scalefac_compress(gr),4)];
   bin_str = [bin_str dec2bin(window_switching_flag,1)];
   for region = 1:3,
      bin_str = [bin_str dec2bin(table_select(gr,region),5)];
   end
   bin_str = [bin_str dec2bin(region0_count(gr),4)];   
   bin_str = [bin_str dec2bin(region1_count(gr),3)];
   bin_str = [bin_str dec2bin(preflag,1)];
   bin_str = [bin_str dec2bin(scalefac_scale(gr),1)];
   bin_str = [bin_str dec2bin(count1table_select(gr),1)];
end