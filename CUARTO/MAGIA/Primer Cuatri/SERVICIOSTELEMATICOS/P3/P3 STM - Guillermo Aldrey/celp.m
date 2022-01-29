function [xhat,e,k,theta0,P,b] = celp(x,N,L,M,c,cb,Pidx)
%  celp --> Cascaded CELP analyzer and synthesizer.
%
%  <Synopsis>
%    [xhat,e,k,theta0,P,b] = celp(x,N,L,M,c,cb,Pidx)
%
%  <Description>
%    The function apply cascaded CELP analyzer and synthesizer to the
%    signal vector x in frames of length N, and the synthesized signal
%    is returned in xhat. The LP analysis performed in each frame is of
%    order M, and the perceptual weighting filter W(z) = A(z)/A(z/c) is
%    determined by the constant c. 
%
%    The excitation parameters k, theta0, P, and b, used to generate the
%    excitation sequence, e(n) are estimated in blocks of length L, so N/L
%    values are obtained for each frame (columns in the output matrices).
%    The analysis-by-synthesis estimation procedure requires search of the
%    codebook given by the L-by-K matrix cb, and pitch search in the range
%    Pidx(1) < P < Pidx(2).
%
%  <See Also>
%    celpana --> CELP analyzer (coder).
%    celpsyn --> CELP synthesizer (decoder).

%  <Revision>
%    Peter S.K. Hansen, IMM, Technical University of Denmark
%
%    Last revised: September 30, 2000
%-----------------------------------------------------------------------

Nx = length(x);                         % Signal length.
F  = fix(Nx/N);                         % No. of frames.
J  = N/L;                               % No. blocks per frame.

% Initialize output signals.
xhat   = zeros(Nx,1);                   % Synthesized signal.
e      = zeros(Nx,1);                   % Excitation signal.
k      = zeros(J,F);                    % Columns are excitation
theta0 = zeros(J,F);                    % parameters per frame.
P      = zeros(J,F);
b      = zeros(J,F);

ebuf  = zeros(Pidx(2),1);               % Vectors with previous excitation
ebuf2 = ebuf; bbuf = 0;                 % samples.
Zf = []; Zw = []; Zi = [];              % Memory hangover in filters.

for (f=1:F)
  fprintf(1,'... Frame no. %g out of %g.\n',f,F);
  n = (f-1)*N+1:f*N;                    % Time index of current speech frame.

  [kappa,kf,theta0f,Pf,bf,ebuf,Zf,Zw] = celpana(x(n),L,M,c,cb,Pidx,bbuf,...
                                                                ebuf,Zf,Zw);

  [xhat(n),ebuf2,Zi] = celpsyn(cb,kappa,kf,theta0f,Pf,bf,ebuf2,Zi);

  % Output excitation signal and parameters for current frame.
  e(n)        = ebuf(Pidx(2)-N+1:Pidx(2));
  k(:,f)      = kf;
  theta0(:,f) = theta0f;
  P(:,f)      = Pf;
  b(:,f)      = bf; bbuf = bf(J);       % Last estimated b used in next frame.
end

%-----------------------------------------------------------------------
% End of function celp
%-----------------------------------------------------------------------
