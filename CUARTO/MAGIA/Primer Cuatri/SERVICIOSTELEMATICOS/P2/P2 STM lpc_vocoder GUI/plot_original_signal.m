function [ss1,es1]=plot_original_signal(graphicPanel3,L,R,nframes,xin,fs);

% plot original speech waveform in top graphics Panel

% INPUTS
%   graphicPanel3: identity of graphics Panel in which to plot original
%   speech signal
%   L: analysis frame length in samples
%   R: analysis frame shift in samples
%   nframes: number of frames in original speech signal
%   xin: original speech signal (scaled from -32768-to-32767
%   fs: speech signal sampling rate

% OUTPUTS
%   ss1: starting sample of first analysis frame
%   es1: ending sample of last analysis frame

% clear graphics Panel 3 (Note: graphics Panel 3 is actually the top
% graphics panel)
        reset(graphicPanel3);
        axes(graphicPanel3);
        cla;
        
% plot original speech signal in graphics Panel 3
        ss1=L/2+1-R;
        es1=L/2+1+nframes*R;
        xinn=xin/max(abs(xin));
        plot(ss1:es1,xinn(ss1:es1),'b');axis([ss1 es1 min(xinn) max(xinn)]);
        xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
        xlabel(xpp),ylabel('Value');
        grid on;legend('original speech signal');
end
