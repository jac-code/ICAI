function plot_excitation_signal(graphicPanel2,L,R,ss1,es1,nframes,ex,fs);

% plot unnormalized excitation signal in graphics Panel 2 (the second
% panel)

% INPUTS
%   graphicPanel2: graphics Panel in which to plot excitation signal
%   L: analysis frame length in samples
%   R: analysis frame shift in samples
%   ss1: starting sample of first analysis frame
%   es1: ending sample of last analysis frame
%   nframes: number of frames in original speech signal
%   ex: unnormalized excitation signal
%   fs: speech sampling rate

% clear graphics Panel 2
        reset(graphicPanel2);
        axes(graphicPanel2);
        cla;

% append zeros if length of ex not quite as long as length of xin
        if (length(ex) < es1)
            ex(length(ex)+1:es1)=0;
        end
        
% plot unnormalized excitation signal in graphics Panel 2
        plot(ss1:es1,ex(ss1:es1),'r');axis([ss1 es1 min(ex) max(ex)]);
        xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
        xlabel(xpp),ylabel('Value');
        grid on;legend('excitation signal');
end