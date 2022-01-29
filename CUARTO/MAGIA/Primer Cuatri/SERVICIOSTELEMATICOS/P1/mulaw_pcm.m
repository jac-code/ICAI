function [sqnr,m_quan,code]=mulaw_pcm(m_samp,L,mu)
 
%MULAW_PCM  mu-law PCM encoding of a sequence
%           [SQNR,A_QUAN,CODE]=MULAw_PCM(m_samp,L,MU).
%           m_samp  = input sequence.
%           L       = number of quantization levels (even).
%           sqnr    = output SQNR (in dB).
%           m_quan  = quantized output before encoding.
%           code    = the encoded output.
 
% Call the mulaw function:
[y,m_max]=mulaw(m_samp,mu);
 
% Call the uniform_pcm function:
[sqnr,y_quan,code]=uniform_pcm(y,L);
 
% Call the invmulaw function:
x = invmulaw(y_quan,mu);
 
m_quan = m_max*x;
sqnr = 20*log10(norm(m_samp)/norm(m_samp - m_quan));
 
