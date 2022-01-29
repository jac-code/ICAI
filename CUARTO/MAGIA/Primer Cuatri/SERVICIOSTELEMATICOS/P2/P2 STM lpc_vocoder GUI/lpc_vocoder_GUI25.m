function lpc_vocoder_GUI25
% Modifiable runGUI file
clc;
clear all;

% USER - ENTER FILENAME
fileName = 'lpc_vocoder_pitch.mat';    
fileData=load(fileName);
temp=fileData(1).temp;

f = figure('Visible','on',...
'Units','normalized',...
'Position',[0,0,1,1],...
'MenuBar','none',...
'NumberTitle','off');

% %SENSE COMPUTER AND SET FILE DELIMITER
switch(computer)				
    case 'MACI64',		char= '/';
    case 'GLNX86',  char='/';
    case 'PCWIN',	char= '\';
    case 'PCWIN64', char='\';
    case 'GLNXA64', char='/';
end

% 
% find speech files directory by going up one level and down one level
% on the directory chain; as follows:
    dir_cur=pwd; % this is the current Matlab exercise directory path 
    s=regexp(dir_cur,char); % find the last '\' for the current directory
    s1=s(length(s)); % find last '\' character; this marks upper level directory
    dir_fin=strcat(dir_cur(1:s1),'speech_files'); % create new directory
    start_path=dir_fin; % save new directory for speech files location

% USER - ENTER PROPER CALLBACK FILE
Callbacks_lpc_vocoder_GUI25(f,temp,start_path);    
%panelAndButtonEdit(f, temp);       % Easy access to Edit Mode

% Note comment PanelandBUttonCallbacks(f,temp) if panelAndButtonEdit is to
% be uncommented and used
end

% GUI Lite 2.5 for lpc vocoder
% 2 Panels
%   #1 - input parameters
%   #2 - graphics displays
% 3 Graphic Panels
%   #1 - original speech signal
%   #2 - excitation signal
%   #3 - synthetic signal
% 1 TitleBox
% 17 Buttons
%   #1 - pushbutton - Speech Directory
%   #2 - popupmenu - Speech Files
%   #3 - editable button - fsr: sampling rate for recording
%   #4 - editable button - nsec: number of seconds for recording
%   #5 - pushbutton - Record Speech
%   #6 - editable button - Lm: analysis frame length in msec
%   #7 - editable button - Rm: analysis frame shift in msec
%   #8 - popupmenu - male/female pitch period range
%   #9 - popupmenu - cepstral pitch switch (to pp1-pp6)
%   #10 - popupmenu - synthesis method
%   #11 - popupmenu - number of overlapping sections
%   #12 - pushbutton - Run LPC Vocoder
%   #13 - pushbutton - Play Original Speech
%   #14 - pushbutton - Play Synthesized Speech
%   #15 - pushbutton - Play Excitation without Gain
%   #16 - pushbutton - Play Excitation with Gain
%   #17 - pushbutton - Close GUI