function decoder(c,motionVect,identifier,flag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MatAC = char('1010','00','01','100','1011', '11010','111000','1111000','1111110110',...
    '1111111110000010', '1111111110000011','1100','111001',...
'1111001',...
'111110110',...
'1111111010',...
'1111111110000100',...
'1111111110000101',...
'1111111110000110',...
'1111111110000111',...
'1111111110001000',...
'11011',...
'11111000',...
'1111110111',...
'1111111110001001',...
'1111111110001010',...
'1111111110001011',...
'1111111110001100',...
'1111111110001101',...
'1111111110001110',...
'1111111110001111',...
'111010',...
'111110111',...
'11111110111',...
'1111111110010000',...
'1111111110010001',...
'1111111110010010',...
'1111111110010011',...
'1111111110010100',...
'1111111110010101',...
'1111111110010110',...
'111011',...
'1111111000',...
'1111111110010111',...
'1111111110011000',...
'1111111110011001',...
'1111111110011010',...
'1111111110011011',...
'1111111110011100',...
'1111111110011101',...
'1111111110011110',...
'1111010',...
'1111111001',...
'1111111110011111',...
'1111111110100000',...
'1111111110100001',...
'1111111110100010',...
'1111111110100011',...
'1111111110100100',...
'1111111110100101',...
'1111111110100110',...
'1111011',...
'11111111000',...
'1111111110100111',...
'1111111110101000',...
'1111111110101001',...
'1111111110101010',...
'1111111110101011',...
'1111111110101100',...
'1111111110101101',...
'1111111110101110',...
'11111001',...
'11111111001',...
'1111111110101111',...
'1111111110110000',...
'1111111110110001',...
'1111111110110010',...
'1111111110110011',...
'1111111110110100',...
'1111111110110101',...
'1111111110110110',...
'11111010',...
'111111111000000',...
'1111111101110111',...
'1111111110111000',...
'1111111110111001',...
'1111111110111010',...
'1111111110111011',...
'1111111110111100',...
'1111111110111101',...
'1111111110111110',...
'111111000',...
'1111111110111111',...
'1111111111000000',...
'1111111111000001',...
'1111111111000010',...
'1111111111000011',...
'1111111111000100',...
'1111111111000101',...
'1111111111000110',...
'1111111111000111',...
'111111001',...
'1111111111001000',...
'1111111111001001',...
'1111111111001010',...
'1111111111001011',...
'1111111111001100',...
'1111111111001101',...
'1111111111001110',...
'1111111111001111',...
'1111111111010000',...
'111111010',...
'1111111111010001',...
'1111111111010010',...
'1111111111010011',...
'1111111111010100',...
'1111111111010101',...
'1111111111010110',...
'1111111111010111',...
'1111111111011000',...
'1111111111011001',...
'11111111111111110',...
'1111111111011010',...
'1111111111011011',...
'1111111111011100',...
'1111111111011101',...
'1111111111011110',...
'1111111111011111',...
'1111111111100000',...
'1111111111100001',...
'1111111111100010',...
'11111111010',...
'1111111111100011',...
'1111111111100100',...
'1111111111100101',...
'1111111111100110',...
'1111111111100111',...
'1111111111101000',...
'1111111111101001',...
'1111111111101010',...
'1111111111101011',...
'111111110110',...
'1111111111101100',...
'1111111111101101',...
'1111111111101110',...
'1111111111101111',...
'1111111111110000',...
'1111111111110001',...
'1111111111110010',...
'1111111111110011',...
'1111111111110100',...
'11111111111111111',...
'1111111111110101',...
'1111111111110110',...
'1111111111110111',...
'1111111111111000',...
'1111111111111001',...
'1111111111111010',...
'1111111111111011',...
'1111111111111100',...
'1111111111111101',...
'1111111111111110');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MatDC=char('00','010','011','100','101','110','1110','11110','111110',...
'1111110','11111110','111111110');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global I1d P4d P7d I10d B2d B3d B5d B6d B8d B9d
%persistent I1d P4d
fid=fopen('Qtable2.txt','r');
array=fscanf(fid,'%e',[8,inf]);
%array=2*array;
array=array;
blocksize=8;
i = 0;


 if identifier==1
    I1d = Idecoder(c,array,MatAC,MatDC);
    %figure;imshow(uint8(I1d))
    
    
end

 if identifier==4
     P4d = pDecoder(c,array,MatAC,MatDC,I1d,motionVect);
     %figure;imshow(uint8(P4d)) 
 end
 
% 
if identifier==7
    P7d = pDecoder(c,array,MatAC,MatDC,P4d,motionVect);
    %figure;imshow(uint8(P7d))
end

if identifier==2 
    if flag==0
        B2d = bDecoder(c,0.5*array,MatAC,MatDC,I1d,motionVect);
        %figure;imshow(uint8(B2d))
        
    elseif flag==1
        B2d = bDecoder(c,0.5*array,MatAC,MatDC,P4d,motionVect);
        %figure;imshow(uint8(B2d))
    end
end

if identifier==3 
    if flag==0
        B3d = bDecoder(c,0.5*array,MatAC,MatDC,I1d,motionVect);
        %figure;imshow(uint8(B3d))
    elseif flag==1
        B3d = bDecoder(c,0.5*array,MatAC,MatDC,P4d,motionVect);
        %figure;imshow(uint8(B3d))
    end
end

if identifier==5 
    if flag==0
        B5d = bDecoder(c,0.5*array,MatAC,MatDC,uint8(P4d),motionVect);
        %figure;imshow(uint8(B5d))
    elseif flag==1
        B5d = bDecoder(c,0.5*array,MatAC,MatDC,uint8(P7d),motionVect);
        %figure;imshow(uint8(B5d))
    end
end

if identifier==6 
    if flag==0
        B6d = bDecoder(c,0.5*array,MatAC,MatDC,P4d,motionVect);
     %   figure;imshow(uint8(B6d))
    elseif flag==1
        B6d = bDecoder(c,0.5*array,MatAC,MatDC,P7d,motionVect);
    %    figure;imshow(uint8(B6d))
    end
end

 if identifier==10
    I10d = Idecoder(c,array,MatAC,MatDC);
    I1d=I10d;
   % figure;imshow(uint8(I10d));
    
end
% 
if identifier==8 
    if flag==0
        B8d = bDecoder(c,0.5*array,MatAC,MatDC,P7d,motionVect);
   %     figure;imshow(uint8(B8d))
    elseif flag==1
        B8d = bDecoder(c,0.5*array,MatAC,MatDC,I10d,motionVect);
  %      figure;imshow(uint8(B8d))
    end
end

if identifier==9
    if flag==0
        B9d = bDecoder(c,0.5*array,MatAC,MatDC,P7d,motionVect);
 %       figure;imshow(uint8(B9d))
    elseif flag==1
        B9d = bDecoder(c,0.5*array,MatAC,MatDC,I10d,motionVect);
%        figure;imshow(uint8(B9d))
    end
end

% imshow(uint8(I1d))
% figure;imshow(uint8(B2d))
% figure;imshow(uint8(B3d))
% figure;imshow(uint8(P4d))
% figure;imshow(uint8(B5d))
% figure;imshow(uint8(B6d))
% figure;imshow(uint8(P7d))
% figure;imshow(uint8(B8d))
% figure;imshow(uint8(B9d))
% figure;imshow(uint8(I10d))