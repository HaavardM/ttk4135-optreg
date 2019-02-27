function [c, ceq] = mycon(z)
    global N mx
    beta = 20;
    lamda_t = 2*pi/3;
    alpha = 0.2;
    ceq = [];
    c = zeros(N, 1);
    for k = 0:N-1
        c(k+1) = alpha*exp(-beta*(z(k*mx+1) - lamda_t)^2)-z(k*mx+5);
    end

end
