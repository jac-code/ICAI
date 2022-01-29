function P = lpcpitch(e,m,N,th,minlag,maxlag)
%  lpcpitch --> Pitch estimation from prediction error sequence.
%
%  <Synopsis>
%    P = lpcpitch(e,m,N,th,minlag,maxlag)
%
%  <Description>
%    The function performs autocorrelation based pitch estimation on
%    the prediction error sequence, e, in overlapping frames of length N.
%    The vector m gives the index of the last sample in each frame. If
%    N is larger than the end point of the first frame, zeros are
%    inserted in the beginning of the prediction error sequence.
%
%    In each frame, the function finds the maximum autocorrelation value
%    for lags in the interval minlag to maxlag. If this peak value is
%    larger than the threshold th*Re(0), then the error frame originates
%    from a voiced speech sound and the corresponding lag index is the
%    pitch period. Estimated pitch values are returned in the vector P
%    having same dimension as vector m.
%
%  <See Also>
%    lpcauto --> Linear Predictor Coefficients.

%  <References>
%  [1] J.R Deller, J.G. Proakis and F.H.L. Hansen, "Discrete-Time
%      Processing of Speech Signals", IEEE Press, p. 333, (2000).
%
%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

% Check the required input arguments.
if (nargin < 6)
  error('Not enough input arguments.')
end

% Number of frames.
F = length(m);

if (m(F) > length(e))
  error('Last sample index in vector m larger than length of signal.')
end

% Insert zeros if frame length N is larger than the one used in LP analysis.
if (m(1) < N)
  e = [zeros(N-m(1),1); e];
  m = m + (N - m(1));
end

% Initialize output argument.
P = zeros(F,1);

for (f=1:F)
  % Sample index of current prediction error frame.
  n = m(f)-N+1:m(f);

  % Short-term autocorrelation.
  [re,eta] = xcorr(e(n),maxlag,'biased');

  % Find max autocorrelation for lags in the interval minlag to maxlag.
  [remax,idx] = max(re(maxlag+minlag+1:2*maxlag+1));

  % If peak value larger than threshold, then lag index is pitch period.
  if (remax > th*re(maxlag+1))
    P(f) = eta(maxlag+minlag+idx);
  end
end

%-----------------------------------------------------------------------
% End of function lpcpitch
%-----------------------------------------------------------------------
