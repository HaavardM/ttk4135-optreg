
function [c, ceq] = myfuncon(z)
    global N mx
    c = zeros(N*4, 1);
    ceq = [];
    freq = 1/N*3*pi;
    for k = 0:N-1
        c(k+1) = z(k*mx+5) + pi/6*sin(k*freq);
    end
    for k = 0:N-1
        c(N+k+1) = -z(k*mx+5) - pi/6*sin(k*freq)-pi/18;
    end
    
    for k = 0:N-1
        c(2*N+k+1) = z(k*mx+1) + pi/6*cos(k*freq);
    end
    
    for k = 0:N-1
        c(3*N+k+1) = -z(k*mx+1) - pi/6*cos(k*freq)-pi/18;
    end
end