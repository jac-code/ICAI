function Callbacks_lpc_vocoder_GUI25(f,C,start_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SENSE COMPUTER AND SET FILE DELIMITER
switch(computer)				
    case 'MACI64',		char= '/';
    case 'GLNX86',  char='/';
    case 'PCWIN',	char= '\';
    case 'PCWIN64', char='\';
    case 'GLNXA64', char='/';
end

x=C{1,1};
y=C{1,2};
a=C{1,3};
b=C{1,4};
u=C{1,5};
v=C{1,6};
m=C{1,7};
n=C{1,8};
lengthbutton=C{1,9};
widthbutton=C{1,10};
enterType=C{1,11};
enterString=C{1,12};
enterLabel=C{1,13};
noPanels=C{1,14};
noGraphicPanels=C{1,15};
noButtons=C{1,16};
labelDist=C{1,17};%distance that the label is below the button
noTitles=C{1,18};
buttonTextSize=C{1,19};
labelTextSize=C{1,20};
textboxFont=C{1,21};
textboxString=C{1,22};
textboxWeight=C{1,23};
textboxAngle=C{1,24};
labelHeight=C{1,25};
fileName=C{1,26};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %PANELS
% for j=0:noPanels-1
% uipanel('Parent',f,...
% 'Units','Normalized',...
% 'Position',[x(1+4*j) y(1+4*j) x(2+4*j)-x(1+4*j) y(3+4*j)-y(2+4*j)]);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GRAPHIC PANELS
for i=0:noGraphicPanels-1
switch (i+1)
case 1
graphicPanel1 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
case 2
graphicPanel2 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
case 3
graphicPanel3 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
case 4
graphicPanel4 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TITLE BOXES
for k=0:noTitles-1
switch (k+1)
case 1
titleBox1 = uicontrol('parent',f,...
'Units','Normalized',...
'Position',[u(1+4*k) v(1+4*k) u(2+4*k)-u(1+4*k) v(3+4*k)-v(2+4*k)],...
'Style','text',...
'FontSize',textboxFont{k+1},...
'String',textboxString(k+1),...
'FontWeight',textboxWeight{k+1},...
'FontAngle',textboxAngle{k+1});
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BUTTONS
for i=0:(noButtons-1)
enterColor='w';
if strcmp(enterType{i+1},'pushbutton')==1 ||strcmp(enterType{i+1},'text')==1
enterColor='default';
end
if (strcmp(enterLabel{1,(i+1)},'')==0 &&...
        strcmp(enterLabel{1,(i+1)},'...')==0) %i.e. there is a label
%creating a label for some buttons
uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i)-labelDist-labelHeight(i+1) ...
(m(2+2*i)-m(1+2*i)) labelHeight(i+1)],...
'Style','text',...
'String',enterLabel{i+1},...
'FontSize', labelTextSize(i+1),...
'HorizontalAlignment','center');
end
switch (i+1)
case 1
button1=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button1Callback);
case 2
button2=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button2Callback);
case 3
button3=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button3Callback);
case 4
button4=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button4Callback);
case 5
button5=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button5Callback);
case 6
button6=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button6Callback);
case 7
button7=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button7Callback);
case 8
button8=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button8Callback);
case 9
button9=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button9Callback);
case 10
button10=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button10Callback);
case 11
button11=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button11Callback);
case 12
button12=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button12Callback);
case 13
button13=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button13Callback);
case 14
button14=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button14Callback);
case 15
button15=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button15Callback);
case 16
button16=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button16Callback);
case 17
button17=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button17Callback);
case 18
button18=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button18Callback);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER CODE FOR THE VARIABLES AND CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Variables
    curr_file=1;
    fs=8000;
    directory_name='abcd';
    wav_file_names='abce';
    fin_path='filename';
    fname='output';
    fnameo='rec_file';
    nsamp=1;
    x=[];
    xin=[];
    ss=1;
    es=19400;
    ppd='pp5';
    Lm=40;
    Rm=10;
    isyn=2;
    of=1;
    p=16;
    iwin=1;
    pitchfile=ppd;
    jdebug=0;
    iplay=0;
    jplay=0;
    sn=[];
    en=[];
    eng=[];
    ipitch=0;
    fsr=8000;
    fsd=8000;
    nsec=4;
    fs=8000;
    imf=1;

% Name the GUI
    set(f,'Name','lpc_vocoder');

% CALLBACKS
% Callback for button1 -- Get Speech Files Directory
 function button1Callback(h,eventdata)
     directory_name=uigetdir(start_path, 'dialog_title');
     A=strvcat(strcat((directory_name),[char,'*.wav']));
     struct_filenames=dir(A);
     wav_file_names={struct_filenames.name};
     set(button2,'String',wav_file_names);
     set(button2,'val',1);
     
% once the popupmenu/drop down menu is created, by default, the first
% selection from the popupmenu/drop down menu id not called
    indexOfDrpDwnMenu=1;
    
% by default first option from the popupmenu/dropdown menu will be loaded
    [curr_file,fs]=loadSelection(directory_name,wav_file_names,indexOfDrpDwnMenu);
 end

% Callback for button2 -- Choose speech file for play and plot
 function button2Callback(h,eventdata)
     indexOfDrpDwnMenu=get(button2,'val');
     [curr_file,fs]=loadSelection(directory_name,wav_file_names,indexOfDrpDwnMenu);
 end

%*************************************************************************
% function -- load selection from designated directory and file
%
function [curr_file,fs]=loadSelection(directory_name,wav_file_names,...
    indexOfDrpDwnMenu);
%
% read in speech/audio file
% fin_path is the complete path of the .wav file that is selected
    fin_path=strcat(directory_name,char,strvcat(wav_file_names(indexOfDrpDwnMenu)));
    
% clear speech/audio file
    clear curr_file;
    
% read in speech/audio signal into curr_file; sampling rate is fs 
    %[curr_file,fs]=wavread(fin_path);
    [curr_file,fs]=audioread(fin_path);
    xin=curr_file*32768;
    
% create title information with file, sampling rate, number of samples
    fname=wav_file_names(indexOfDrpDwnMenu);
    FS=num2str(fs);
    nsamp=num2str(length(curr_file));
    file_info_string=strcat('  file: ',fname,', fs: ',FS,' Hz, nsamp:',nsamp);
    
% read in filename (fname) from cell array
    fname=wav_file_names{indexOfDrpDwnMenu};
    fnameo=fname;
end

% Callback for button3 -- fsr: speech sampling rate for recording
 function button3Callback(h,eventdata)
    %fsr=str2num(get(button3,'string'));
    Index=get(button3,'val');
     a = [6000 8000 10000 16000 20000];
     fsr = a(Index); 
 end

% Callback for button4 -- nsec: number of seconds for recording
 function button4Callback(h,eventdata)
    nsec=str2num(get(button4,'string'));
 end

% Callback for button5 -- record speech file
 function button5Callback(h,eventdata)
     
% clear all graphic Panels; display speech waveform, and choose region of
% interest in graphicPanel3
    clear_all_graphics(graphicPanel1,graphicPanel2,graphicPanel3,graphicPanel4);

% check editable buttons for changes
    button3Callback(h,eventdata);
    button4Callback(h,eventdata);
    
% begin recording after hitting OK on msg box
    uiwait(msgbox('Ready to Record -- Hit OK to Begin','Record','modal'));
    
% record speech file with fs=fsr and nsec duration
%    [y]=record_speech(fsr,nsec);
recobj=audiorecorder(fsr,16,1);
recordblocking(recobj,nsec);
y=getaudiodata(recobj);
    y=round(y/max(abs(y))*32767);
    yfilt=highpass_filter(y,fsr);
    y=yfilt;
    fs=fsr;
    fname='rec_file';
    xin=y;
    
% plot speech waveform on graphicPanel3; choose section of interest; clear panels
    axes(graphicPanel3);
    plot(0:length(xin)-1,xin,'r','LineWidth',2);
    xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
    xlabel(xpp); ylabel('Value'); axis tight; grid on;
    legend('recorded speech signal');
    
% choose region for lpc vocoder
    [X,Y]=ginput(2);
    ss=round(X(1)); if (ss < 1) ss=1; end
    es=round(X(2)); if (es > length(xin)) es=length(xin); end
    xin=xin(ss:es);
    
% play back recorded and filtered speech
    soundsc(xin,fs);
    xin=xin/max(abs(xin))*32767;
    ipitch=1;
    fnameo='rec_file';
 end

% Callback for button18 -- define region of speech signal for LPC vocoder
    function button18Callback(h,eventdata)
        
% clear all graphic Panels; display speech waveform, and choose region of
% interest in graphicPanel3
    clear_all_graphics(graphicPanel1,graphicPanel2,graphicPanel3,graphicPanel4);
        
% plot speech waveform on graphicPanel3; choose section of interest; clear panels
    axes(graphicPanel3);
    plot(0:length(xin)-1,xin,'r','LineWidth',2);
    xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
    xlabel(xpp); ylabel('Value'); axis tight; grid on;
    legend('speech signal');
    
% choose region for lpc vocoder
    [X,Y]=ginput(2);
    ss=round(X(1)); if (ss < 1) ss=1; end
    es=round(X(2)); if (es > length(xin)) es=length(xin); end
    yin=xin(ss:es);
    xin=yin;
    
% play back recorded and filtered speech
    soundsc(xin,fs);
    xin=xin/max(abs(xin))*32767;
    end

% Callback for button6 -- Lm: analysis frame length in msec
 function button6Callback(h,eventdata)
     Lm=str2num(get(button6,'string'));
     if (Lm < 1 || Lm > 100)
         waitfor(errordlg('The frame length must be between 1 and 100'));
         return;
     end
 end

% Callback for button7 -- Rm: analysis frame shift in msec
 function button7Callback(h,eventdata)
     Rm=str2num(get(button7,'string'));
     if (Rm < 1 || Rm > 100)
         waitfor(errordlg('The frame shift must be between 1 and 100'));
         return;
     end
 end

% Callback for button8 -- imf: male/female/combined pitch period region
 function button8Callback(h,eventdata)
     imf=get(button8,'val');
 end

% Callback for button9 -- ppd: pitch period contour for utterance
 function button9Callback(h,eventdata)
     ppd=get(button9,'val');
     if (ppd == 1)
         ipitch=1;
         pitchfile='out_pitch_period_cepstral';
     else
         ipitch=0;
     end
     
     if (ppd <= 7 && ppd >= 2)
        pitchfile=strcat('pp',num2str(ppd-1));
     elseif (ppd == 8)
         pitchfile='out_autocorrelation';
     elseif (ppd == 9)
         pitchfile='out_cepstral';
     elseif (ppd == 10)
         pitchfile='out_sift';
     end
     pitchfile=strcat('',pitchfile,'');
 end

% Callback for button10 -- isyn: synthesis method (2 for 10 msec excitation
% with frame overlap; 1 for 40 msec excitation with HW weighting
 function button10Callback(h,eventdata)
     isyn=get(button10,'val');
 end

% Callback for button11 -- of: number of overlapping frames (0-3)
 function button11Callback(h,eventdata)
     of=str2num(get(button11,'string'));
     if (of < 0 || of > 3)
         waitfor(errordlg('The number of overlapping frames must be between 0 and 3'));
         return;
     end
 end

% Callback for button12 -- Run LPC Vocoder
 function button12Callback(h,eventdata)
     
% clear all graphic panels for each new run
    clear_all_graphics(graphicPanel1,graphicPanel2,graphicPanel3,graphicPanel4);
     
% check editable buttons for changes
    button6Callback(h,eventdata);
    button7Callback(h,eventdata);
    button8Callback(h,eventdata);
    button9Callback(h,eventdata);
    button10Callback(h,eventdata);
    button11Callback(h,eventdata);
    p=16;
    iwin=1;
    
% determine starting and ending samples (speech > 0)
    es=length(xin);
    xx=find(xin(:) ~= 0);
    es=min(es,xx(end)+1);
    ss=1;
    
% setup lpc vocoder
    setup_lpc_vocoder(xin,fs,ss,es,pitchfile,Lm,Rm,p,iwin,isyn,of,...
        fname,imf,graphicPanel3,graphicPanel4,graphicPanel2,graphicPanel1,...
        ipitch,fname,titleBox1);
 end

% Callback for button13 -- play original speech signal
 function button13Callback(h,eventdata)
     soundsc(xin,fs);
 end

% Callback for button14 -- play synthetic speech signal
 function button14Callback(h,eventdata)
	fname=fnameo(1:length(fnameo)-4);
	%[sn,fs]=wavread(strcat(fname,'_synthetic.wav'));
    [sn,fs]=audioread(strcat(fname,'_synthetic.wav'));
	soundsc(sn,fs);
 end

% Callback for button15 -- play unnormalized excitation without gain
 function button15Callback(h,eventdata)
	fname=fnameo(1:length(fnameo)-4);
	%[sn,fs]=wavread(strcat(fname,'_unnormalized_excitation.wav'));
    [sn,fs]=audioread(strcat(fname,'_unnormalized_excitation.wav'));
	soundsc(sn,fs);
 end

% Callback for button16 -- play normalized excitation with gain
 function button16Callback(h,eventdata)
	fname=fnameo(1:length(fnameo)-4);
	%[sn,fs]=wavread(strcat(fname,'_normalized_excitation.wav'));
    [sn,fs]=audioread(strcat(fname,'_normalized_excitation.wav'));
	soundsc(sn,fs);
 end

% Callback for button17 -- Close GUI
 function button17Callback(h,eventdata)
     fclose('all');
     close(gcf);
 end
end