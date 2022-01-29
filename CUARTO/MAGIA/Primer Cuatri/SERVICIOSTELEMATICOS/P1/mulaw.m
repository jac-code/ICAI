function [y,m_max]=mulaw(m_samp,mu)
%MULAW      mu-law nonlinearity for nonuniform PCM
%           Y      = MULAW(M_SAMP,MU).
%           M_SAMP = input vector.
 
m_max = max(abs(m_samp));
y     =(log(1+mu*abs(m_samp/m_max))./log(1+mu)).*signum(m_samp);
