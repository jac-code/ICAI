function [ar,xi,e,m] = lpcauto(x,M,win,Olap)
%  lpcauto --> Linear Predictor Coefficients.
%
%  <Synopsis>
%    [ar,xi,e,m] = lpcauto(x,M,win,Olap)
%
%  <Description>
%    The function performs crosscorrelation based LP analysis on the
%    signal vector x in overlapping, windowed frames. The frame length
%    is determined by the length of the window function vector win, and
%    the overlap is given by Olap. In each frame, the function finds the
%    coefficients, ar=[1 -a(1) ... -a(M)], of an M'th order forward linear
%    predictor
% 
%      xhat(n) = a(1)*x(n-1) + a(2)*x(n-2) + ... + a(M)*x(n-M)
%
%    such that the sum of the squares of the prediction errors
%
%      ehat(n) = x(n) - xhat(n)
%
%    is minimized. The LP coefficients for each frame are returned in the
%    columns of the matrix ar, and the prediction error energies for the
%    0'th to the M'th order solution are returned in the columns of the
%    matrix xi.
%
%    The residual signal e is obtained by applying the inverse filters
%    A(z) to the speech frames (rectangular window). In overlapping
%    regions the residual signals will be interpolated according to the
%    window function used to find the LP coefficients. The vector m gives
%    the index of the last sample in each frame.

%  <References>
%  [1] J.R Deller, J.G. Proakis and F.H.L. Hansen, "Discrete-Time
%      Processing of Speech Signals", IEEE Press, chapter. 5, (2000).
%
%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

% Check the required input arguments.
if (nargin < 4)
  error('Not enough input arguments.')
end

% Number of data points.
Nx = length(x);

% Frame length is given by the window length.
N = length(win);
if (N == 1)
  N   = win;                % If win is a scalar, then use
  win = ones(N,1);          % a rectangular window of this length.
end

if (Nx < N)
  error('The window length cannot be larger than the signal length.')
elseif (N <= Olap)
  error('The overlap must be smaller than the window length.')
end

% Number of frames.
F = fix((Nx-Olap)/(N-Olap));

% Initialize output arguments.
ar = zeros(M+1,F);
xi = zeros(M+1,F);
e  = zeros(Nx,1);
m  = zeros(F,1);

% Time index vectors.
n  = 1:N;                   % Index of current speech frame.
n1 = 1:Olap;                % Overlap in start of frame.
n2 = N-Olap+1:N;            % Overlap in end of frame.
n3 = Olap+1:N;              % From overlap in start to end of frame.

% Overlap-add weights in start and end of frame, respectively.
win1 = win(n1)./(win(n1)+win(n2)+eps);
win2 = win(n2)./(win(n1)+win(n2)+eps);

for (f=1:F)
  % Short-term autocorrelation.
  [r,eta] = xcorr(x(n).*win,M,'biased');

  % LP analysis based on Levinson-Durbin recursion.
  [a,xi(:,f),kappa] = durbin(r(M+1:2*M+1),M);
  ar(:,f) = [1; -a];
  
  % Prediction error signal obtained by inverse filtering.
  ehat = filter(ar(:,f),1,x(n));
  e(n) = [e(n(n1)).*win2 + ehat(n1).*win1; ehat(n3)]; % Overlap-add.

  m(f) = n(N);              % Time index of last point in frame.
  n = n + (N-Olap);         % Shift time index to next speech frame.
end

%-----------------------------------------------------------------------
% End of function lpcauto
%-----------------------------------------------------------------------
