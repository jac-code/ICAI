function xhat = lpcsyn(A,P,G,m)
%  lpcsyn --> Synthesized speech from LP parameters.
%
%  <Synopsis>
%    xhat = lpcsyn(A,P,G,m)
%
%  <Description>
%    The function takes the AR parameters A, the pitch period P, the
%    gain G, and the vector m with indices of the last sample in each
%    frame as inputs, and returns the synthesized speech signal xhat.
%
%  <See Also>
%    lpcauto  --> Linear Predictor Coefficients.
%    lpcpitch --> Pitch estimation from prediction error sequence.
%    lpcgain  --> Gain estimation from prediction error energy.

%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

% Check the required input arguments.
if (nargin < 4)
  error('Not enough input arguments.')
end

% Number of frames.
F = length(m);

% Frame length.
N = m(2) - m(1);

xhat = [];
for (f=1:F)
  if (P(f))                                  % Voiced frame.
    e = zeros(N,1); e(1:P(f):N) = 1;         % Impulse-train excitation.
  else                                       % Unvoiced frame.
    e = randn(N,1);                          % White noise excitation.
  end
  xhat = [xhat; filter(G(f),A(:,f),e)];
end

%-----------------------------------------------------------------------
% End of function lpcsyn
%-----------------------------------------------------------------------
