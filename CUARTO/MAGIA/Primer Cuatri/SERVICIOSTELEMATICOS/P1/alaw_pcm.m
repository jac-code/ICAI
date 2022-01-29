function [sqnr,y_quan,code]=alaw_pcm(m_samp,L,A)
  
% Call the alaw function:
[y,m_max]=alaw(m_samp,A);
 
% Call the uniform_pcm function:
[sqnr,y_quan,code]=uniform_pcm(y,L);
 
% Call the invalaw function:
x = invalaw(y_quan,A);
 
m_quan = m_max*x;
sqnr = 20*log10(norm(m_samp)/norm(m_samp - m_quan));