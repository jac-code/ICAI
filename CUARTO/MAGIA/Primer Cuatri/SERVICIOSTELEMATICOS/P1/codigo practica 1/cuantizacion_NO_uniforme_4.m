% MATLAB script for Illustrative Example nonuniform_ex4.m
clc;clear;close all
% echo on
 
no_samp = 500;
L       = [16 64 128];
mu      = 255;
for i=1:length(L)
    randn('state',0)
    m_samp=randn(1,no_samp);
    [sqnr,m_quan,code]=mulaw_pcm(m_samp,L(i),mu);
    %----------------------------------------------------------------------
    L(i)
    %----------------------------------------------------------------------
    pause   % Press a key to see the SQNR.
    sqnr
%     pause % Press a key to see the first five input values.
%     m_samp(1:5)
%     pause % Press a key to see the first five quantized values.
%     m_quan(1:5)
%     pause % Press a key to see the first five codewords.
%     code(1:5,:)
    
    % Plot the quantization error for each sample.
    q_error = m_samp - m_quan;
    figure; plot ([1:no_samp],q_error)
    title('diferencia entre valor real y valor aproximado')
    
    
    % Plot the quantized value as a function of the input value. 
    [Y,Index]=sort(m_samp); % Ordena de menor a mayor las muestras
    figure; plot(Y,m_quan(Index))
    title('Muestras ordenadas de menor a mayor frente cuantizadas indexadas por el orden anterior')
end
echo off   
