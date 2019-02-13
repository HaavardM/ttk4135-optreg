function [c, ceq] = mycon(X)
    global alpha beta lambda_t N
    ceq = [];
    c = zeros(N, 1);
    for index = 0:N-1
        c(index+1) = alpha*exp(beta*(X(index*6+1) - lambda_t)^2)-X(index*6+5);
    end
end