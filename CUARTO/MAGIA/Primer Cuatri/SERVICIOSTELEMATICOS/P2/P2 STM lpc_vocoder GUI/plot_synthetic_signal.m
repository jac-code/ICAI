function plot_synthetic_signal(graphicPanel4,ss1,es1,sn,fs);

% initialize graphics
        reset(graphicPanel4);
        axes(graphicPanel4);
        cla;

        plot(ss1:es1,sn(ss1:es1),'b');axis([ss1 es1 min(sn) max(sn)]);
        xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
        xlabel(xpp),ylabel('Value');
        grid on;legend('synthetic signal');
end