function G = lpcgain(xi,P)
%  lpcgain --> Gain estimation from prediction error energy.
%
%  <Synopsis>
%    G = lpcgain(xi,P)
%
%  <Description>
%    The gain across speech frames, returned in vector G, can be
%    estimated from the prediction error energies in vector xi and
%    the pitch periods in vector P as
%
%      G = sqrt(xi),         unvoiced case
%      G = sqrt(P*xi),       voiced case
%
%  <See Also>
%    lpcauto  --> Linear Predictor Coefficients.
%    lpcpitch --> Pitch estimation from prediction error sequence.

%  <References>
%  [1] J.R Deller, J.G. Proakis and F.H.L. Hansen, "Discrete-Time
%      Processing of Speech Signals", IEEE Press, p. 325, (2000).
%
%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

% Check the required input arguments.
if (nargin < 2)
  error('Not enough input arguments.')
end

% Number of frames.
F = length(xi);

% Initialize output argument.
G = zeros(F,1);

for (f=1:F)
  if (P(f))
    G(f) = sqrt(P(f)*xi(f));            % Voiced frame.
  else
    G(f) = sqrt(xi(f));                 % Unvoiced frame.
  end
end

%-----------------------------------------------------------------------
% End of function lpcgain
%-----------------------------------------------------------------------
