
%The following implementation steps have been made for the devised algorithm, which is based on 2D-wavelet.
%1. Reading an image of either gray scale or RGB image.
%2. Converting the image into grayscale if the image is RGB.
%3. Decomposition of images using wavelets for the level N.
%4. Selecting and assigning a wavelet for compression.
%5. Generating threshold coefficients using Birge-Massart strategy.
%6. Performing the image compression using wavelets.
%7. Computing and displaying the results such as compressed image, retained energy and Zero coefficients.
%8. Decompression the image based on the wavelet decomposition structure.
%9. Plotting the reconstructed image.
%10. Computing and displaying the size of original image, compressed image and decompressed image.

% Wavelet image compression - RGB images
clear all;
close all; 
% Reading an image file
%im = input('Enter a image');
%X=imread(im);
%X=imread('santorini.jpg');
X=imread('robin-glauser.bmp');
% inputting the decomposition level and name of the wavelet
% See Wavelet Families in MATLAB
n=input('Enter the decomposition level:   ');
wname = input('Enter the name of the wavelet:   ');
 x = double(X);
NbColors = 255;
map = gray(NbColors);
 x = uint8(x);
%Conversion of RGB to Grayscale 
% x = double(X);
% xrgb  = 0.2990*x(:,:,1) + 0.5870*x(:,:,2) + 0.1140*x(:,:,3);
% colors = 255;
% x = wcodemat(xrgb,colors);
% map = pink(colors);
% x = uint8(x);
% A wavelet decomposition of the image

%wname — Name of orthogonal or biorthogonal wavelet
%Names to use:   'haar' | 'db1' | 'db2' | 'coif1' | 'coif2' | ...
    
[c,s] = wavedec2(x,n,wname); % More details in definition of wavedec2
% wdcbm2 for selecting level dependent thresholds  
alpha = 1.5; m = 2.7*prod(s(1,:));
[thr,nkeep] = wdcbm2(c,s,alpha,m)
% Compression
[xd,cxd,sxd,perf0,perfl2] = wdencmp('lvd',c,s,wname,n,thr,'h');
disp('Compression Ratio');
disp(perf0);
% Decompression
R = waverec2(c,s,wname);
 rc = uint8(R);
% Plot original and compressed images.
subplot(221), image(x); 
colormap(map); 
title('Original image')
subplot(222), image(xd); 
colormap(map);
title('Compressed image')
% Displaying the results
xlab1 = ['2-norm rec.: ',num2str(perfl2)];
xlab2 = [' %  -- zero cfs: ',num2str(perf0), ' %'];
xlabel([xlab1 xlab2]);
subplot(223), image(rc); 
colormap(map);
title('Reconstructed image');
%Computing the image size
disp('Original Image');
imwrite(x,'original.tiff');
imfinfo('original.tiff')
disp('Compressed Image');
imwrite(xd,'compressed.tiff');
imfinfo('compressed.tiff')
disp('Decompressed Image');
imwrite(rc,'decompressed.tiff');
imfinfo('decompressed.tiff')
 



