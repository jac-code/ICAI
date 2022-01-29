function [y,m_max]=alaw(m_samp,A)
 
m_max = max(abs(m_samp));
y = zeros(size(m_samp,1),1);
for i =1:size(m_samp,1)
    
    if abs(m_samp(i)/m_max) < (1/A)
        y(i)    = ((A*abs(m_samp(i)/m_max))/(1+log(A)))*signum(m_samp(i));        
    else
        y(i)    = ((1+log(A*abs(m_samp(i)/m_max)))/(1+log(A)))*signum(m_samp(i));
    end
end