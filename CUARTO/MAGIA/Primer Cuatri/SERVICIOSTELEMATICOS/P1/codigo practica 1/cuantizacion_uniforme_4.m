% MATLAB script for Illustrative Example uniform_ex4.m
clc;clear;close all
% echo on
 
no_samp = 500;
L       = [16 64 128];
 
for i=1:length(L)
    randn('state',0)
    m_samp= randn(1,no_samp);
    [sqnr,m_quan,code]=uniform_pcm(m_samp,L(i));
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
    title('error entre muestra y valor discretizado') 
    
    % Plot the quantized value as a function of the input value. 
    [Y,Index]=sort(m_samp);
    figure; plot(Y,m_quan(Index))
end
echo off    
