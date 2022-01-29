function ac = lpcweight(ar,c)
%  lpcweight --> LPC based perceptual weighting filter.
%
%  <Synopsis>
%    ac = lpcweight(ar,c)
%
%  <Description>
%    The function takes the LP coefficients, ar = [1 -a(1) ... -a(M)],
%    and the parameter, c, as inputs, and returns the coefficients of
%    the filter function A(z/c) in the vector ac.
%
%  <See Also>
%    lpcana --> Linear prediction analysis.

%  <References>
%  [1] J.R Deller, J.G. Proakis and F.H.L. Hansen, "Discrete-Time
%      Processing of Speech Signals", IEEE Press, p. 477, (2000).
%
%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

% Linear predictor order.
M = length(ar);

% The i'th coefficient of A(z/c) is given by ar(i)*c^(i-1).
ac = ar;
ci = c;
for (i=2:M)
  ac(i) = ar(i)*ci;
  ci = ci*c;
end

%-----------------------------------------------------------------------
% End of function lpcweight
%-----------------------------------------------------------------------
