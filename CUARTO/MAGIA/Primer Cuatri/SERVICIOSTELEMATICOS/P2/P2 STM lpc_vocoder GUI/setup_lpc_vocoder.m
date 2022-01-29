    function setup_lpc_vocoder(xin,fs,ss,es,pitchfile,Lm,Rm,p,...
            iwin,isyn,of,filename,imf,graphicPanel3,graphicPanel4,...
            graphicPanel2,graphicPanel1,ipitch,fname,titleBox1)
%
% lpc vocoder code
%
% Inputs:
%   xin: speech file
%   fs: speech sampling rate
%   ss: starting sample in file
%   es: ending sample in file
%   pitchfile: pitch period file (pp1-pp6, out_autocorrelation,
%       out_cepstral, out_sift
%   Lm: analysis frame length in msec
%   Rm: analysis frame shift in msec
%   p: lpc system order
%   iwin: lpc analysis window type (1:Hamming, 2:Rectangular)
%   isyn: lpc synthesis method (2: 10 msec excitation with overlap;
%       1: 40 msec excitation with HW weighting
%   of: number of overlapping sections (0-3)
%   filename: speech filename
%   imf: male/female/combined pitch period range
%

% initial play options
    iplay=0;
    jplay=0;
    jdebug=0;
    
% open file 'output_lpc_vocoder.txt' to write all excitation information
    fidw=fopen('output_lpc_vocoder.txt','w');
    fprintf(fidw,'LPC Vocoder Runs \n');
    
% convert Lm and Rm to samples
    L=round(Lm*fs/1000);
    R=round(Rm*fs/1000);
    
% create window array according to iwin parameter
    if (iwin == 1)
        win=hamming(L)';
    else
        win=ones(1,L);
    end

% normalize speech file to range [-1 1]
    xinm=max(-min(xin),max(xin));
    xinn=xin/xinm;
    
% lpc analysis of xin from ss to es
    [Afile,Gfile,nframes,~,exct]=lpc_analysis(xin,ss,es,L,R,p,win);
    
% plot original speech signal on second from top graphics panel
    [ss1,es1]=plot_original_signal(graphicPanel3,L,R,nframes,xin,fs);

% cepstral pitch detector
    [p1m,pitch]=gen_pitch(xin,ss,es,fs,imf,L,R,nframes);
        
% plot pitch period contour
    plot_pitch_period_contour(ss1,es1,L,R,nframes,p1m,graphicPanel1);
 
% create excitation signal from pitch period contour
    [e]=create_excitation_signal(nframes,R,p1m,fidw);

% create unnormalized (ex) and normalized (exn) excitation
    [ex,exn,Gain]=normalize_excitation(e,R,nframes,Gfile);
    
% save unnormalized and normalized excitation signals in files
    save_excitations(ex,exn,fs,filename);
    
% plot unnormalized excitation signal
    plot_excitation_signal(graphicPanel2,L,R,ss1,es1,nframes,ex,fs);
    
% synthesize speech by convolving in windows the excitation with the lpc
% system function
    [s]=synthesize_speech(ss,es,L,R,nframes,isyn,e,Gfile,Afile,p,of,win);
    
% play out synthetic speech and save in a wav file
    sn=s/max(max(s),-min(s));
    s=s*32000/max(max(s),-min(s)); % resynthesized signal
    % fprintf('resynthesized signal \n');
    fname=filename(1:length(filename)-4);
    savewav(s,strcat(fname,'_synthetic.wav'),fs);
    
% plot synthetic signal
    plot_synthetic_signal(graphicPanel4,ss1,es1,sn,fs);
    
% close read and write files
    fclose(fidw); 
    
% title GUI plot
        stitle=sprintf(' file: %s, Lm: %d, Rm: %d, p: %d, isyn: %d, of: %d',...
            fname,Lm,Rm,p,isyn,of);
        stitle1=strcat('LPC Vocoder -- ',stitle);
        set(titleBox1,'string',stitle1);
        set(titleBox1,'FontSize',20);
    end