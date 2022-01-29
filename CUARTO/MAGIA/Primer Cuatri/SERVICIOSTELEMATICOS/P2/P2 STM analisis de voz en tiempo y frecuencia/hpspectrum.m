function HPSx = hpspectrum(x,N,R)
%  hpspectrum --> Harmonic product spectrum.
%
%  <Synopsis>
%    HPSx = hpspectrum(x,N,R)
%
%  <Description>
%    The harmonic product spectrum consists of the product of compressed
%    copies of the original spectrum. The frequency axis is compressed
%    by integer factors (1 to R), so the harmonics line up and reinforce
%    the fundamental frequency. x is a signal segment and N is the
%    number of points in the FFT.

%  <References>
%  [1] J.R Deller, J.G. Proakis and F.H.L. Hansen, "Discrete-Time
%      Processing of Speech Signals", IEEE Press, p. 261, (2000).
%
%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

% Check the required input arguments.
if (nargin < 3)
  error('Not enough input arguments.')
end

% Find the highest frequency for which the product can be made.
k = 1:R:N/2;
K = length(k);

% DFT of signal segment.
X = fft(x.*hann(length(x)),N);

% Product of the spectra compressed by R down to 1.
HPSx = X(k);
for (r=R-1:-1:1)  
  HPSx = HPSx.*X(1:r:r*K);
end

%-----------------------------------------------------------------------
% End of function hpspectrum
%-----------------------------------------------------------------------
