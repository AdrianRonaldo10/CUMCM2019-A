function p = pressure(rho)
%PRESSURE compute pressure from density
    p = fzero(@(p)density(p) - rho, [0,1000]);
end
