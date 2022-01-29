function lpcplot(A,Nfft,Fs,m)
%  lpcplot --> Plots AR filter frequency response.
%
%  <Synopsis>
%    lpcplot(A,Nfft,Fs)
%    lpcplot(A,Nfft,Fs,m)
%
%  <Description>
%    The function plots the magnitude spectrum of the digital filter
%
%             jw    1                    1
%      Theta(e) = ----- = ---------------------------------
%                    jw               -jw              -jnw
%                 A(e)    a(1) + a(2)e + .... + a(n+1)e
%
%    given denominator coefficients in vector A. The frequency response
%    is evaluated at Nfft points equally spaced around the upper half of
%    the unit circle. Fs is the sampling frequency in Hz.
%
%    When A is a matrix, the function operates on the columns of A, i.e.,
%    evaluates one frequency response per column. The vector m gives
%    the index of the last sample in each frame used to obtain the columns
%    of A, so the length of m must be the same as the number of columns
%    in the matrix A. In this case the filter response is plot as function
%    of time, m, and frequency (mesh plot).

%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

[M,N] = size(A);

if (N==1)
  [Theta,F] = freqz(1,A,Nfft,Fs);

  plot(F,20*log10(abs(Theta)));

  xlabel('Frequency, {\it F}  [Hz]');
  ylabel('Magnitude, |\theta(\omega)|  [dB]');
else
  if (length(m) ~= N)
    error('The column dimension of A must be equal to the length of m.')
  end
  
  Theta = zeros(Nfft,N);
  for (n=1:N)
    [Theta(:,n),F] = freqz(1,A(:,n),Nfft,Fs);
  end

  MeshHndl = meshz(m,F,20*log10(abs(Theta)));
  axis ij; view(-45,45); set(MeshHndl,'MeshStyle','Column');
  axis tight; axis 'auto y'; axis 'auto z';

  xlabel('Sample Number, {\it n}');
  ylabel('Frequency, {\it F}  [Hz]');
  zlabel('Magnitude, |\theta(\omega)|  [dB]');
end

%-----------------------------------------------------------------------
% End of function lpcplot
%-----------------------------------------------------------------------
