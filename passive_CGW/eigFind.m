function [eigJ, stable] = eigFind(FUN,q,walker)
    n = length(q);
    J = zeros(n,n);

    for i=1:n
        qtemp1=q; 
        qtemp2=q;
        qtemp1(i)=qtemp1(i) + 1e-6; 
        qtemp2(i)=qtemp2(i) - 1e-6; 
        J(:,i)=(feval(FUN,0,qtemp1,walker)-feval(FUN,0,qtemp2,walker));
    end
    J = J/2e-6;
    eigJ = eig(J);
    if all(all(eigJ < 1)) && all(all(eigJ > -1))
        stable = 1;
    else
        stable = 0;
    end
end