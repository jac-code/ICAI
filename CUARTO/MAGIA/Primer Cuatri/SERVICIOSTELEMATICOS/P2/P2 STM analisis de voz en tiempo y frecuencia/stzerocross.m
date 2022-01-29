function Zx = stzerocross(x,N)
%  stzerocross --> Short-term zero crossing measure using a sliding window.
%
%  <Synopsis>
%    Zx = stzerocross(x,N)
%
%  <Description>
%    An initial short-term zero crossing measure Zx(N+1) based on the
%    (N+1)-sample vector x(1:N+1) is updated with the new sample x(N+2)
%    and downdated with the oldest sample x(1), resulting in Zx(N+2).
%    This update procedure of the short-term zero crossing estimate
%    continues until the sliding window has reached the end of the
%    signal x.

%  <References>
%  [1] J.R Deller, J.G. Proakis and F.H.L. Hansen, "Discrete-Time
%      Processing of Speech Signals", IEEE Press, p. 245, (2000).
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

% Number of estimates to make.
M  = length(x);
Zx = zeros(M,1);

% First zero crossing estimate.
Zx(1:N+1) = sum(abs(sign(x(2:N+1)) - sign(x(1:N))))/(2*N);

% Updating of the zero crossing estimate.
for (m=(N+2):M)
  Zx(m) = Zx(m-1) + (abs(sign(x(m)) - sign(x(m-1))) ...
                  -  abs(sign(x(m-N)) - sign(x(m-N-1))))/(2*N);
end

%-----------------------------------------------------------------------
% End of function stzerocross
%-----------------------------------------------------------------------
