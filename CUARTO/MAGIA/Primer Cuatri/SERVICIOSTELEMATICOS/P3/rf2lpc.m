function a = rf2lpc(kappa)
%  rf2lpc --> Convert reflection coefficients to prediction polynomial.
%
%  <Synopsis>
%    a = rf2lpc(kappa)
%
%  <Description>
%    The function computes the prediction polynomial, a, based on the
%    reflection coefficients, kappa.
%
%  <See Also>
%    durbin --> Levinson-Durbin Recursion.
%    lpc2rf --> Convert prediction polynomial to reflection coefficients.

%  <References>
%  [1] J.R Deller, J.G. Proakis and F.H.L. Hansen, "Discrete-Time
%      Processing of Speech Signals", IEEE Press, p. 300, (2000).
%
%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

M = length(kappa);
a = zeros(M,1);

for (j=1:M)
  a(j)     = kappa(j);
  a(1:j-1) = a(1:j-1) - kappa(j)*a(j-1:-1:1);
end

%-----------------------------------------------------------------------
% End of function rf2lpc
%-----------------------------------------------------------------------
