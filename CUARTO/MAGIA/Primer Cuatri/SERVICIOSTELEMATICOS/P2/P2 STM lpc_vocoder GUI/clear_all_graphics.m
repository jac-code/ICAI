function clear_all_graphics(graphicPanel1,graphicPanel2,graphicPanel3,graphicPanel4);
% clear all 4 graphicPanels for LPC Vocoder

    reset(graphicPanel1); axes(graphicPanel1); cla;
    reset(graphicPanel2); axes(graphicPanel2); cla;
    reset(graphicPanel3); axes(graphicPanel3); cla;
    reset(graphicPanel4); axes(graphicPanel4); cla;
end