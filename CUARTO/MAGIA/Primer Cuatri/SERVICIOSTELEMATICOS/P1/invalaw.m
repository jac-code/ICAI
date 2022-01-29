function x = invalaw(y,A)

x = zeros(size(y,1),1);
for i=1:size(y,1)
    
    if abs(y(i)) < (1/(1+log(A)))
        x(i)    = ((abs(y(i))*(1+log(A)))/A)*signum(y(i));   
    else
        x(i)    = (exp(abs(y(i))*(1+log(A))-1)/A)*signum(y(i));
    end
    
end