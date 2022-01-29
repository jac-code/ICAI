function plot_pitch_period_contour(ss1,es1,L,R,nframes,p1m,graphicPanel4);

% plot pitch period contour in graphics Panel 1 (which is actually the
% third graphics Panel)

% clear graphics Panel 4
axes(graphicPanel4);
cla;

% plot pitch period contour in graphics Panel 4
    plot(1:nframes,p1m(1:nframes),'r','LineWidth',2);grid on;
    axis([0 nframes+1 0 max(p1m)+5]);
    xlabel('Frame');ylabel('Pitch Period');
end