function Encabezado(padding_bit,bitrate_index)
%ENCABEZADO Escritura del encabezado.
%
%   ENCABEZADO(PADDING_BIT,BITRATE_INDEX)
%   Realiza la escritura del encabezado para cada trama del archivo MP3.
%
%   PADDING_BIT es la bandera que indica la escritura de un byte de relleno
%   dentro del flujo de bits para ajustar la tasa de transferencia promedio,
%   obtenida en WAV2MP3. BITRATE_INDEX es un valor que indica la tasa de bits
%   del archivo, obtenido en WAV2MP3.
%
%   Ver también WAV2MP3.

global bin_str

% Inicialización de variables.
syncword = 4095; % 12 bits en '1', para sincronización de la trama.
ID = 1; % Indica que es audio MPEG.
layer = 1;  % El esquema usado es la Capa III.
protection_bit = 1; % No se incluye CRC.
sampling_frequency = 0; % La frecuencia de muestreo es 44100 Hz.
private_bit = 0; % No se usan private_bits dentro del flujo de bits.
mode = 3; % Modo monofónico.
mode_extension = 0; % No se usa extensión del modo.
copyright = 0; % El archivo MP3 no tiene copyright.
original_or_copy = 0; % El archivo MP3 es una copia.
emphasis = 0; % No se usa ningún tipo de preénfasis.

% Escribe el encabezado en la cadena binaria bin_str.
bin_str = [bin_str dec2bin(syncword,12)];
bin_str = [bin_str dec2bin(ID,1)];
bin_str = [bin_str dec2bin(layer,2)];
bin_str = [bin_str dec2bin(protection_bit,1)];
bin_str = [bin_str dec2bin(bitrate_index,4)];
bin_str = [bin_str dec2bin(sampling_frequency,2)];
bin_str = [bin_str dec2bin(padding_bit,1)];
bin_str = [bin_str dec2bin(private_bit,1)];
bin_str = [bin_str dec2bin(mode,2)];
bin_str = [bin_str dec2bin(mode_extension,2)];
bin_str = [bin_str dec2bin(copyright,1)];
bin_str = [bin_str dec2bin(original_or_copy,1)];
bin_str = [bin_str dec2bin(emphasis,2)];