function F = Analisis_fft(ENT)
%ANALISIS_FFT Análisis Transformada Rápida de Fourier.
%
%   F=ANALISIS_FFT(ENT)
%   Calcula el espectro auditivo usando la Transformada rápida de Fourier.
%   El espectro (vector F) se expresa en decibeles, y sólo tiene 512 valores
%   debido a la simetría de la FFT. La cantidad de puntos de la transformada
%   es 1024 (Capa II). La variable de entrada (vector ENT) equivale a
%   1152 muestras de audio PCM. Con el fin de usar la FFT de 1024 puntos para
%   las 1152 muestras, se escogen las 1024 muestras centrales de las 1152.
%
%   A las 1024 muestras centrales se les aplica una ventana de Hanning convencional
%   antes de calcular su FFT, para suavizar los extremos del intervalo de señal.

% Escoge las 1024 muestras centrales del vector ENT y las almacena en el vector s.
s = ENT(65:1088);

% Sólo se realizan los cálculos si el vector s no es un vector de ceros. De lo
% contrario, el espectro auditivo (vector F) es un vector de -INF.
if s ~= 0
   % Calcula la ventana de Hanning de 1024 puntos (vector h).
   h = sqrt(8/3) * hanning(1024);
   
   % Obtiene la densidad espectral de potencia (vector F) a través de la FFT.
   % F se reduce a la mitad de componentes, por la simetría de la FFT.
   F = max(20*log10(abs(fft(s .* h))/1024),-200);
   F = F(1:512);
else
   F = zeros(512,1)-200; % -200 dB corresponde a -INF.
end