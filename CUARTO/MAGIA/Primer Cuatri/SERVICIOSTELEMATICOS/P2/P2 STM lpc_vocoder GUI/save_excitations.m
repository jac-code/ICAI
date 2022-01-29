function save_excitations(ex,exn,fs,filename);

% save both unnormalized and normalized excitation signals in files

% INPUTS
%   ex: unnormalized excitation signal
%   exn: normalized excitation signal
%   fs: sampling rate of excitation signals
%   filename: original speech filename

% eliminate .wav from speech filename
    fname=filename(1:length(filename)-4);
    
% save excitation without gain to a wav file:
% fname_unnormalized_excitation.wav
    er=ex*32000/max(max(ex),-min(ex));
    savewav(er,strcat(fname,'_unnormalized_excitation.wav'),fs);
    
% save excitation with gain to a wav file
% fname_normalized_excitation.wav
    er=exn*32000/max(max(exn),-min(exn));
    savewav(er,strcat(fname,'_normalized_excitation.wav'),fs);
end