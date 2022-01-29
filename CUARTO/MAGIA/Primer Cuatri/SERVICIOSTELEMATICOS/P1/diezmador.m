function [s] = diezmador(x,M)
% x = señal de entrada ; M = factor de diezmado
i=1;
   for j=1:1:length(x)
        if(mod(j,M)==0)
            s(i)=x(j);
            i=i+1;
        end
   end
end