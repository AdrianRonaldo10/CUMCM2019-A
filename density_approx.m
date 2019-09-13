function rho0 = density_approx(p0)
%DENSITY_APPROX 快速查表获取密度
    load('Rho_P_model.mat');
    ind = floor(p0 * 100) + 1;
    rho0 = rho(ind);
end

