% pathnew_matlab_central
%

% path-to-speech: starting directory definition
% path-to-speech='C:\data\matlab_central_speech'
%path_to_speech = 'C:\Users\masanz\Desktop\lpc_vocoder'

%path_to_speech = 'C:\Users\masanz\Documents\Servicios Telemáticos Multimedia\Tema 3 Codificacion de Voz\Practica 2 códigos\P2 STM lpc_vocoder GUI'

% paths to GUI toolkit
path(strcat(path_to_speech,'\gui_lite_2.6\GUI Lite v2.6'),path);

% paths to speech toolkit
path(strcat(path_to_speech,'\functions_lrr'),path);
path(strcat(path_to_speech,'\speech_files'),path);

% path to highpass filter mat files
path(strcat(path_to_speech,'\highpass_filter_signal'),path);

% path to cepstral coefficient training files
path(strcat(path_to_speech,'\VQ'),path);

% path to cepstral coefficients
path(strcat(path_to_speech,'\cepstral coefficients'),path);

% path to lrr isolated digit files set for training and testing
path(strcat(path_to_speech,'\isolated_digit_files\testing set'),path);
path(strcat(path_to_speech,'\isolated_digit_files\training set'),path);