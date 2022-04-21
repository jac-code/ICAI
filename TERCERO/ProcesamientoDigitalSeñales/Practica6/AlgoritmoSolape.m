function [yn] = AlgoritmoSolape(xn, Num, L)
    % numero de coefientes del filtro = 101
    p = length(Num);
    
    % nº de muestras del bloque o tamaño del bloque real
    longitud_bloque = L - (p-1); % 400
    
    % tamaño del trozo de solapamiento o nº de ceros en bloque inicial
    longitud_solape = p - 1; % 100 --> depende del número
    
    % longtiud de nuestra señal de entrada
    longitud_xn = length(xn); % 442354
    
    % creamos la señal final con ceros --> tiene misma longitud que señal
    % de entrada xn
    yn = zeros(longitud_xn, 1);
    
    % nos hace falta calcular la DFT del filtro para luego poder hacer la
    % concvolución circular
    filtro = [Num zeros(1, L - p)];
    filtro_dft = fft(filtro, length(filtro));
    
    % dividimos nuestra señal en bloques y para cada bloque hacemos 1) DFT,
    % 2) multiplicar por DFT del filtro y 3) IDFT
    for j = 0:longitud_bloque:(longitud_xn-longitud_bloque)
        if j == 0   % primer bloque
            % creamos el primer el bloque que consta de parte de solape con
            % ceros y la parte de la señal correspondiente
            x_subj = [zeros(longitud_solape, 1); xn(1:longitud_bloque, 1)];
            
            % hacemos DFT del bloque mediante la fft()
            x_subj_dft = fft(x_subj, length(x_subj));
            
            % convolución circular --> muestra a muestra
            convolucion_circular = x_subj_dft.*filtro_dft.';
            
            % calculamos la IDFT
            y_subj = ifft(convolucion_circular, length(convolucion_circular));
            
            % nos quedamos con el trozo sin la zona de solape y metemos en
            % nuestra señal final
            yn(1:longitud_bloque, 1) = y_subj(p:end, 1);
            
        else % no primer bloque
            % los bloques que no son el primero cogen p-1 muestras del
            % anterior y L-(p-1) muestras de la señal
            x_subj =  xn((j-p+2):(j+longitud_bloque), 1);
            
            % hacemos DFT del bloque mediante la fft()
            x_subj_dft = fft(x_subj, length(x_subj));
            
            % convolución circular --> muestra a muestra
            convolucion_circular = x_subj_dft.*filtro_dft.';
            
            % calculamos la IDFT
            y_subj = ifft(convolucion_circular, length(convolucion_circular));
            
            % nos quedamos con el trozo sin la zona de solape y lo metemos
            % en nuestra señal final
            yn(j+1:j+longitud_bloque, 1) = y_subj(p:end, 1);
        end
    end
end