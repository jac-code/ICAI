function Px = stpower(x,N)
%  stpower --> Short-term power computation using a sliding window.
%
%  <Synopsis>
%    Px = stpower(x,N)
%
%  <Description>
%    An initial short-term power estimate Px(N) based on the N-sample
%    vector x(1:N) is updated with the new sample x(N+1) and downdated
%    with the oldest sample x(1), resulting in Px(N+1). This update
%    procedure of the short-term power estimate continues until the
%    sliding window has reached the end of the signal x.

%  <References>
%  [1] J.R Deller, J.G. Proakis and F.H.L. Hansen, "Discrete-Time
%      Processing of Speech Signals", IEEE Press, p. 246, (2000).
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

if (N > length(x))
  error('The window length N can not be longer than the sequence length.')
end

% Make sure that x is a column vector.
x = x(:);

% Number of power estimates to make.
M  = length(x);
Px = zeros(M,1);

% First power estimate.
Px(1:N) = x(1:N)'*x(1:N)/N;

% Updating of the power estimate.
for (m=(N+1):M)
  Px(m) = Px(m-1) + (x(m)^2 - x(m-N)^2)/N;
end

%-----------------------------------------------------------------------
% End of function stpower
%-----------------------------------------------------------------------
