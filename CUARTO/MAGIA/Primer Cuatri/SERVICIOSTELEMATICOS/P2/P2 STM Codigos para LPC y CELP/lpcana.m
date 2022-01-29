function [ar,xi,kappa,ehat] = lpcana(x,M)
%  lpcana --> Linear prediction analysis.
%
%  <Synopsis>
%    [ar,xi,kappa,ehat] = lpcana(x,M)
%
%  <Description>
%    The function performs autocorrelation based LP analysis on the
%    signal vector x using the Levinson-Durbin recursion. Thus, the
%    function finds the coefficients, ar=[1 -a(1) ... -a(M)], of an
%    M'th order forward linear predictor
% 
%      xhat(n) = a(1)*x(n-1) + a(2)*x(n-2) + ... + a(M)*x(n-M)
%
%    such that the sum of the squares of the prediction errors
%
%      ehat(n) = x(n) - xhat(n)
%
%    is minimized. The reflection coefficients are returned in the
%    vector kappa, and the prediction error energies for the 0'th to
%    the M'th order solution are returned in the vector xi. Finally,
%    the residual signal, ehat, is obtained by applying the inverse
%    filter A(z) to the signal frame.

%  <References>
%  [1] J.R Deller, J.G. Proakis and F.H.L. Hansen, "Discrete-Time
%      Processing of Speech Signals", IEEE Press, chapter. 5, (2000).
%
%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

% Short-term autocorrelation.
[rx,eta] = xcorr(x,M,'biased');

% LP analysis based on Levinson-Durbin recursion.
[a,xi,kappa] = durbin(rx(M+1:2*M+1),M);
ar = [1; -a];

% Prediction error signal obtained by inverse filtering.
ehat = filter(ar,1,x);

%-----------------------------------------------------------------------
% End of function lpcana
%-----------------------------------------------------------------------
