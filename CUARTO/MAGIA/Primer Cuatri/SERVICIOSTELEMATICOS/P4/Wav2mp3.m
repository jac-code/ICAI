%WAV2MP3 Convierte un archivo WAV de Microsoft en un archivo MP3.
%
%   Convierte un archivo de sonido WAV de Microsoft, en un archivo de
%   sonido MP3, de acuerdo a las especificaciones dadas en el est�ndar
%   ISO/IEC 11172-3.
%
%   El archivo WAV debe ser monof�nico, con frecuencia de muestreo igual
%   a 44100 Hz y en formato PCM.
%
%   El archivo resultante es creado con el mismo nombre del archivo WAV
%   original, y est� codificado en formato MPEG-1 Capa III, con las
%   siguientes caracter�sticas:
%
%   - Tasas de transferencia = 96...320 Kbps.
%   - Frecuencia de muestreo = 44100 Hz.
%   - Modo = Monof�nico.
%   
%   Noticia Legal:
%   El est�ndar ISO/IEC 11172-3 es propiedad de la Organizaci�n Internacional
%   para la Estandarizaci�n ISO. Todos los derechos reservados.

clear all
clc
disp(' ')
disp('                      CODIFICADOR MP3 EN MATLAB')
disp(' ')
disp('    Este programa convierte un archivo de sonido WAV de Microsoft, en un')
disp('    archivo de sonido MP3, de acuerdo a las especificaciones dadas en el')
disp('    est�ndar internacional ISO/IEC 11172-3.')
disp(' ')
disp('    El archivo WAV debe ser monof�nico, con frecuencia de muestreo igual')
disp('    a 44100 Hz y en formato PCM.')
disp(' ')
disp('    El archivo resultante es creado con el mismo nombre del archivo WAV')
disp('    original, y est� codificado en formato MPEG-1 Capa III, con las')
disp('    siguientes caracter�sticas:')
disp(' ')
disp('    - Tasas de transferencia = 96...320 Kbps.')
disp('    - Frecuencia de muestreo = 44100 Hz.')
disp('    - Modo = Monof�nico.')
disp(' ')
disp(' ')

% Declaraci�n de variables globales, las cuales son:
% X: B�fer FIFO del filtro subbanda.
% XR: Vector de muestras subbanda.
% gr: Gr�nulo (escalar).
% xmin: Vector de distorsiones permitidas.
% scalefac_l: Vector que contiene los factores de escala para bloques largos.
% bin_str: Cadena de caracteres, en la cual se almacenan todos los datos del
%          archivo MP3 (en formato binario) que deben ser escritos en el disco
%          duro.
global X XR gr xmin scalefac_l bin_str

% Inicializa el b�fer FIFO (vector X) del filtro subbanda para el an�lisis.
% Inicializa la matriz S que almacena los valores del filtro subbanda.
X = zeros(1,512);
S = zeros(36,32);

% Asigna el archivo WAV de entrada a codificar.
archivo = input('Introduce el nombre del archivo que deseas codificar con extension\n','s');

% Obtiene la informaci�n del archivo WAV a codificar.
%[PMA,Fs,bits] = wavread(archivo,1); % S�lo lee la primera muestra.
%[PMA,Fs] = audioread(archivo,[1,1]); % S�lo lee la primera muestra.
[PMA,Fs] = audioread(archivo); % Lee todo fichero
%SIZ = wavread(archivo,'size'); % Obtiene el tama�o total del archivo.
SIZ = size((audioread(archivo))); % Obtiene el tama�o total del archivo.

% Si la frecuencia de muestreo no es 44100 Hz, se interrumpe la codificaci�n.
if Fs ~= 44100
   fserror = ['Archivo WAV a ',int2str(Fs),' Hz no soportado.'];
   error(fserror)
end

% Si el archivo no es monof�nico, se procesa el canal izquierdo.
if SIZ(2) == 2
   warning('El archivo WAV es estereof�nico, se procesar� el canal izquierdo.')
end

% Asigna la tasa de transferencia.
disp(' ')
disp('Las siguientes tasas de bits est�n disponibles (en Kbps):')
disp('96, 112, 128, 160, 192, 224, 256, � 320')
tasa = input('Introduce la tasa de bits deseada\n');
disp(' ')

% Inicializaci�n de variables, de acuerdo con la tasa de bits escogida.
switch tasa
case 96
   bitrate_index = 7; % �ndice de la tasa de bits.
   ajuste = 1; % Para ajustar el tama�o entero en bytes de la trama.
   ajgg = 11; % Para ajustar global_gain.
case 112
   bitrate_index = 8;
   ajuste = 2;
   ajgg = 10;
case 128
   bitrate_index = 9;
   ajuste = 3;
   ajgg = 9;
case 160
   bitrate_index = 10;
   ajuste = 1;
   ajgg = 9;
case 192
   bitrate_index = 11;
   ajuste = 3;
   ajgg = 8;
case 224
   bitrate_index = 12;
   ajuste = 1;
   ajgg = 8;
case 256
   bitrate_index = 13;
   ajuste = 3;
   ajgg = 7;
case 320
   bitrate_index = 14;
   ajuste = 3;
   ajgg = 7;
otherwise
   error(['La tasa de bits escogida (', num2str(tasa),' Kbps) no es soportada.'])
end

% Asigna el tiempo de codificaci�n.
max_rsize = fix(SIZ(1)/1152)*1152;
seg = max_rsize/44100;
tiempo = input(['�Cu�ntos segundos desea codificar (m�nimo 0.10449, m�ximo ',...
      num2str(seg),' seg.)?\n(ENTER para codificar todo el archivo).\n']);

% Obtiene el �ltimo valor del n�mero de muestras del archivo WAV que sea m�ltiplo
% de 1152. En otras palabras, se obliga a que la cantidad de muestras del archivo
% WAV sea m�ltiplo de 1152. En este paso, se eliminan entre 1 y 1151 muestras PCM
% (son las �ltimas muestras del archivo WAV y, por lo tanto, no son procesadas).
if isempty(tiempo)
   rsize = max_rsize;
else
   rsize = fix(tiempo*44100/1152)*1152;
end
if rsize < 4608
   error('La cantidad de tiempo es insuficiente')
elseif rsize > max_rsize
   warning(['El archivo WAV s�lo dura ', num2str(seg),...
         ' segundos, procesando todo el archivo.'])
   rsize = max_rsize;
end

disp('Okay, espere unos minutos...')

tic
% Carga las tablas necesarias para el an�lisis psicoac�stico.
[UA,MAP,UES] = Umbral_absoluto;
LBC = Limites_banda_critica;

% Carga las tablas necesarias para los c�digos de Huffman.
% Tablas A y B para los cu�druplos count1, proporcionadas
% por el est�ndar ISO 11172-3.
tabla_0 = [1 4 4 5 4 6 5 6 4 5 5 6 5 6 6 6; % hlen.
   1 5 4 5 6 5 4 4 7 3 6 0 7 2 3 1]; % hcod en formato decimal.
tabla_1 = [ones(1,16)*4; % hlen.
   15:-1:0]; % hcod en formato decimal.

% Carga los coeficientes de la ventana del an�lisis (vector C).
load('Ci.mat')

% Tabla de las bandas del factor de escala (Para bloques largos y 44.1 kHz).
SFBT = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21;
   4 4 4 4 4 4 6 6 8 8 10 12 16 20 24 28 34 42 50 54 76;
   1 5 9 13 17 21 25 31 37 45 53 63 75 91 111 135 163 197 239 289 343;
   4 8 12 16 20 24 30 36 44 52 62 74 90 110 134 162 196 238 288 342 418];

% Tabla para scalefac_compress.
SFC = [0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4; % slen1.
   0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3; % slen2.
   0 1 2 3 5 5 6 7 8 8 9 10 4 11 12 13 14 14 14 15]; % scalefac_compress.

% Calcula el n�mero promedio de bits disponibles para main_data, por gr�nulo
% (sin incluir el bit_reservoir).
% Inicializa las variables usadas para el control del formato.
init_mean_bits = fix(tasa*1000*(1152/44100)/2)-(84+ajuste);
bit_reservoir = 0;
padding_bit = 0;
rest = 0;

% Inicializaci�n de variables para el formato del flujo de bits, de acuerdo con
% la tasa de bits escogida. Se inicializan:
% main_data_begin: Indica d�nde empiezan los datos principales de la primera trama.
% mbr: M�ximo permitido para bit_reservoir.
% mmdb: M�ximo permitido para main_data_begin.
% mdt: Cantidad m�xima de bits para main_data, por trama.
main_data_begin = 0;
if tasa == 96 | 112 | 128 | 160
   mbr = init_mean_bits*2;
else
   mbr = 4088;
end
mmdb = mbr/8;
mdt = init_mean_bits*2;

% Ciclo Principal. Analiza grupos de 1152 muestras PCM.
% Cada grupo se convierte en una trama MP3.

for a = 1:1152:rsize,
   
   % Almacena los �ltimos 576 valores de la trama anterior (matriz S).
   U576 = S(19:36,:);
   S = []; % Reinicia la matriz del filtro subbanda para cada gr�nulo.
   MDCT = []; % Reinicia la matriz MDCT.
   system_const = 8; % Reinicia el valor de la constante del sistema.
   
   % Lee el valor de 1152 muestras PCM desde el archivo de audio WAV.
   %ENT = wavread(archivo,[a a+1151]);
   ENT = audioread(archivo,[a a+1151]);
      
   %%% AN�LISIS PSICOAC�STICO (Modelo I), Parte 1.
   
   % Realiza un an�lisis FFT para calcular la densidad espectral de potencia.
   F = Analisis_fft(ENT);
   
   % Encuentra las componentes tonales (senoidales) y no-tonales (ruidosas)
   % de la se�al de audio.
   [BS,LT,LNT] = Componentes_tonales(F,UA,MAP,LBC);
   
   % Reduce las componentes enmascarantes: elimina todas las componentes
   % enmascarantes irrelevantes.
   [BSR,LTR,LNTR] = Reduccion(LT,LNT,BS,UA,MAP);
   
   % Calcula los umbrales de enmascaramiento individual.
   [UET,UENT] = Umbrales_enmasc_individual(F,LTR,LNTR,UA,MAP);
   
   % Calcula el umbral de enmascaramiento global.
   UEG = Umbral_enmasc_global(UES,UET,UENT);
   
   % Determina el umbral de enmascaramiento m�nimo en cada subbanda.
   % Este paso no se realiza para la Capa III. Se puede usar para ampliar
   % el codificador a las Capas I y/o II.
   %UEM = Umbral_enmasc_minimo(UEG,MAP);
   
   %%% FILTRADO SUBBANDA, Parte 1.
   
   % Filtrado subbanda para el an�lisis. En la capa III se obtienen 36
   % muestras subbanda consecutivas en el tiempo para cada una de las
   % 32 subbandas (matriz S de 1152 valores).
   for b = 1:32:1152,
      S = [S; Filtro_subbanda(ENT(b:b+31),C)];
   end
   
   %%% AN�LISIS PSICOAC�STICO (Modelo I), Parte 2.
   
   % Los siguientes pasos no se realizan para la Capa III, por lo tanto, han sido
   % desactivados. Pueden ser usados por cualquier persona interesada en el proyecto,
   % para ampliar el codificador a las Capas I y/o II.

   % Calcula los factores de escala.
   %FDE = Factores_escala(S);
   
   % Determina el nivel de presi�n sonora en cada subbanda.
   %NPS = Nivel_presion_sonora(F,FDE);
   
   % Calcula la relaci�n se�al a m�scara.
   %SMR = NPS-UEM;
   
   for gr = 1:2,
      
      %%% FILTRADO SUBBANDA, Parte 2.
      
      % Calcula la MDCT con 50% de solapamiento.
      for sb = 1:32,
         MDCT = [MDCT; Transf_discreta_coseno(S,U576,sb,gr)];
      end
      
      % Reduce el aliasing introducido por el 50% de solapamiento de la MDCT.
      XR = Aliasing(MDCT(1+576*(gr-1):576*gr));
      
      %%% CUANTIZACI�N Y CODIFICACI�N
      
      % Calcula los bits disponibles para cada gr�nulo (incluye el bit_reservoir).
      mean_bits = init_mean_bits + bit_reservoir;
      % Chequea la m�xima cantidad de bits permitida para cada gr�nulo.
      if mean_bits > 4095
         mean_bits = 4095;
      end
      
      % Si no hay datos de audio, entonces devuelve ciertos valores por
      % defecto. Si se trata del primer gr�nulo, entonces se procesa el
      % segundo gr�nulo. Si est� procesando el segundo gr�nulo, entonces
      % la ejecuci�n contin�a en la etapa de formato.
      if XR == 0,
         scalefac_scale(gr) = 0;
         scalefac_l(:,gr) = zeros(21,1);
         IX(:,gr) = zeros(576,1);
         IS(:,gr) = zeros(576,1);
         count1table_select(gr) = 0;
         big_values(gr) = 0;
         region0_count(gr) = 0;
         region1_count(gr) = 0;
         table_select(gr,:) = zeros(1,3);
         preflag = 0;
         global_gain(gr) = 210 - 8; % Es decir, 210-system_const.
         scalefac_compress(gr) = 0;
         part2_3_length(gr) = 0;
         bit_reservoir = mean_bits;
         S = zeros(36,32);
         SHT = zeros(256,6,gr);
         slen1(gr) = 0;
         slen2(gr) = 0;
         rlb(gr,:) = zeros(1,3);
         fe(gr,:) = zeros(1,3);
         ff(gr,:) = zeros(1,3);
         count1(gr) = 0;
      else
         % Inicializaci�n de variables.
         scalefac_scale(gr) = 0;
         scalefac_l(:,gr) = zeros(21,1);
         
         % Calcula la distorsi�n permitida, seg�n el modelo psicoac�stico.
         xmin = Distorsion_permitida(SFBT,UA,UEG);
         
         % Ciclo interno. Chequea la tasa de bits. Si el vector IX requiere m�s
         % bits de los permitidos para ser codificado, repite el ciclo interno;
         % hasta que la cantidad disponible de bits sea suficiente para codificar
         % el espectro cuantizado (vector IX).
         [IX(:,gr),IS(:,gr),SHT(:,:,gr),overall_bitsum,count1table_select(gr),...
               big_values(gr),region0_count(gr),region1_count(gr),table_select(gr,:),...
               qquant,quantanf,rlb(gr,:),count1(gr),fe(gr,:),ff(gr,:)] = ...
            Ciclo_interno(XR,system_const,SFBT);
         while mean_bits - 74 < overall_bitsum,
            system_const = system_const - 1;
            [IX(:,gr),IS(:,gr),SHT(:,:,gr),overall_bitsum,count1table_select(gr),...
                  big_values(gr),region0_count(gr),region1_count(gr),table_select(gr,:),...
                  qquant,quantanf,rlb(gr,:),count1(gr),fe(gr,:),ff(gr,:)] = ...
               Ciclo_interno(XR,system_const,SFBT);
         end
         
         % Ciclo externo. Chequea la distorsi�n. Si la distorsi�n m�xima
         % es excedida, vuelve a llamar el ciclo interno, de acuerdo con
         % los requerimientos del est�ndar internacional ISO/IEC 11172-3.
         % En este paso se incluyen las condiciones para terminar los ciclos;
         % si alguna de ellas se cumple, la ejecuci�n de los ciclos se detiene
         % y los datos obtenidos hasta ese momento son usados para la etapa de
         % formato.
         [XFSF,preflag] = Ciclo_externo(SFBT,IX(:,gr),qquant,quantanf,...
            scalefac_scale(gr));
         % Si alguna banda excede la distorsi�n permitida, entonces se chequean
         % las condiciones para terminar los ciclos. En el caso de que las
         % condiciones para terminaci�n de los ciclos no se cumplan, entonces se
         % repite el ciclo interno.
         while length(find(xmin < XFSF)) > 0,
            % Chequea si todas las bandas del factor de escala ya han sido amplificadas,
            % en cuyo caso se terminan los ciclos.
            if length(find(scalefac_l(:,gr) ~= 0)) == 21
               break
            end
            % Chequea el m�ximo de los factores de escala, teniendo en cuenta
            % el campo scalefac_scale.
            if (max(scalefac_l(1:11,gr))==15 | max(scalefac_l(12:21,gr))==7)...
                  & scalefac_scale(gr)== 0
               % scalefac_scale se pone en '1' y scalefac_l se pone en '0'.
               scalefac_l(:,gr) = zeros(21,1);
               scalefac_scale(gr) = 1;
            end
            if (max(scalefac_l(1:11,gr))==15 | max(scalefac_l(12:21,gr))==7)...
                  & scalefac_scale(gr)==1
               % Se terminan los ciclos.
               break
            end
            % Si no se cumple ninguna condici�n para la terminaci�n de los ciclos,
            % entonces se repite el ciclo interno.
            [IX(:,gr),IS(:,gr),SHT(:,:,gr),overall_bitsum,count1table_select(gr),...
                  big_values(gr),region0_count(gr),region1_count(gr),table_select(gr,:),...
                  qquant,quantanf,rlb(gr,:),count1(gr),fe(gr,:),ff(gr,:)] = ...
               Ciclo_interno(XR,system_const,SFBT);
            while mean_bits - 74 < overall_bitsum,
               system_const = system_const - 1;
               [IX(:,gr),IS(:,gr),SHT(:,:,gr),overall_bitsum,count1table_select(gr),...
                     big_values(gr),region0_count(gr),region1_count(gr),...
                     table_select(gr,:),qquant,quantanf,rlb(gr,:),count1(gr),...
                     fe(gr,:),ff(gr,:)] = Ciclo_interno(XR,system_const,SFBT);
            end
            [XFSF,preflag] = Ciclo_externo(SFBT,IX(:,gr),qquant,quantanf,...
               scalefac_scale(gr));
         end
         
         % Calcula la ganancia global del sistema.
         % Primero, calcula el vector IX sin realizar el redondeo (especialmente
         % usado s�lo para este c�lculo).
         % IXGG: IX para global_gain.
         IXGG = (abs(XR)/(2^((qquant+quantanf)/4))) .^ 0.75 - 0.0946;
         % Despu�s, calcula la informaci�n del intervalo de cuantizaci�n (vector iic)
         % para cada una de las 576 muestras de audio del gr�nulo.
         iic = zeros(576,1);
         ifqstep = 2^(0.5*(1+scalefac_scale(gr)));
         for h = SFBT,
            for q = h(3):h(4),
               iic(q) = 4*log2(abs(XR(q))*ifqstep^scalefac_l(h(1),gr)/(abs(IXGG(q))^...
                  (4/3)));
            end
         end
         iic(419:576)=4.*log2(abs(XR(419:576)).*ifqstep./abs(IXGG(419:576)).^(4/3));
         % Por �ltimo, calcula global_gain.
         global_gain(gr) = round(mean(iic))+210-system_const-qquant-ajgg;
         
         % Chequea el valor de global_gain (se debe tener en cuenta que este campo
         % se escribe en la informaci�n secundaria, y consume 8 bits).
         if global_gain(gr) < 0
            global_gain(gr) = 0;
         end
         if global_gain(gr) > 255
            global_gain(gr) = 255;
         end
                  
         % Calcula la cantidad de bits necesaria para codificar los
         % factores de escala.
         if max(scalefac_l(1:11,gr)) ~= 0
            slen1(gr) = fix(log2(max(scalefac_l(1:11,gr))))+1;
         else
            slen1(gr) = 0;
         end
         if max(scalefac_l(12:21,gr)) ~= 0
            slen2(gr) = fix(log2(max(scalefac_l(12:21,gr))))+1;
         else
            slen2(gr) = 0;
         end
         scalefac_compress(gr) = SFC(3,4*slen1(gr)+slen2(gr)+1);
         
         % Corrige los valores de slen1 y slen2, para evitar una escritura
         % incorrecta del flujo de bits, ocasionada por valores de slen1 y
         % slen2 que no fueron incluidos en la tabla de scalefac_compress
         % proporcionada por el est�ndar ISO/IEC 11172-3.
         if scalefac_compress(gr) == 5
            slen1(gr) = 1;
            slen2(gr) = 1;
         end
         if scalefac_compress(gr) == 8
            slen1(gr) = 2;
            slen2(gr) = 1;
         end
         if scalefac_compress(gr) == 14
            slen1(gr) = 4;
            slen2(gr) = 2;
         end
         
         % Calcula la cantidad total de bits que usa el espectro cuantizado
         % (vector IX m�s los factores de escala), y se determina cu�ntos bits
         % quedan disponibles para el pr�ximo gr�nulo.
         part2_3_length(gr) = overall_bitsum + slen1(gr)*11 + slen2(gr)*10;
         bit_reservoir = mean_bits - part2_3_length(gr);
      end
      
   end
   
   %%% FORMATO DEL FLUJO DE BITS.
   
   % Para cada trama, determina si es necesario activar padding_bit con el fin de
   % ajustar la tasa de bits promedio. Antes, se calcula la cantidad de tramas.
   frames = (a+1151)/1152;
   if frames > 1
      dif = rem(144000*tasa,Fs);
      rest = rest - dif;
      if rest < 0
         padding_bit = 1;
         rest = rest + Fs;
      else
         padding_bit = 0;
      end
   end
   
   % Escribe el encabezado como una cadena binaria de texto (ASCII).
   Encabezado(padding_bit,bitrate_index);
   
   % Escribe la informaci�n secundaria como una cadena binaria de texto (ASCII).
   Info_secundaria(main_data_begin,part2_3_length,big_values,...
      global_gain,scalefac_compress,table_select,region0_count,region1_count,...
      preflag,scalefac_scale,count1table_select);
   
   % Escribe los c�digos de Huffman y los factores de escala como una cadena
   % binaria de texto (ASCII).
   Datos_principales(IX,IS,SHT,slen1,slen2,big_values,table_select,rlb,...
      fe,ff,tabla_0,tabla_1,count1,count1table_select,main_data_begin,padding_bit,mdt);
   
   % Chequea el valor de bit_reservoir, de tal manera que nunca permite que
   % main_data est� repartido entre m�s de 2 tramas. Adem�s, redondea el valor
   % de main_data_begin, de tal manera que sea m�ltiplo de 8 (main_data_begin
   % se especifica en bytes).
   if tasa == 320
      main_data_begin = 0;
      bit_reservoir = 0;
   else
      if bit_reservoir > mbr
         main_data_begin = mmdb;
         bit_reservoir = mbr;
      else
         main_data_begin = fix(bit_reservoir/8);
         bit_reservoir = main_data_begin*8;
      end
   end
end

% Transforma la cadena binaria de texto ASCII (bin_str) en un vector de valores
% binarios (unos y ceros) en formato decimal, y escribe este vector como un archivo
% binario, de acuerdo con los requerimientos del est�ndar ISO/IEC 11172-3 (usando
% el formato de m�quina big-endian).
[n m]=size(archivo);
archivo_n=archivo(1:m-4);
fid = fopen([archivo_n '.mp3'],'wb','b');
fwrite(fid,bin_str-48,'ubit1');
fclose(fid);

% Indica que el archivo MP3 ya ha sido creado.
disp([sprintf('\n'),'El archivo ',archivo_n,'.mp3 ha sido terminado.'])
toc
clear Fs IXGG MAP SIZ PMA X a b bits dif fid gr h iic q rest ifqstep mdt
clear rsize sb v bit_reservoir bitrate_index init_mean_bits mean_bits mbr mmdb ajgg
clear archivo ENT LBC SFBT SFC SHT U576 UA UES tabla_0 tabla_1 C ans bin_str tasa
clear tiempo seg max_rsize ajuste
