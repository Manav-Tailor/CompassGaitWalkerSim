function F = fixedpt(q,walkerDim)
    t0 = 0;
    qplus = onestep(t0,q,walkerDim);
    F = q - qplus; % trying to set F = 0
end