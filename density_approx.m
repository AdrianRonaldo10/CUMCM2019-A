function rho0 = density_approx(p0)
%DENSITY_APPROX ���ٲ���ȡ�ܶ�
    load('Rho_P_model.mat');
    ind = floor(p0 * 100) + 1;
    rho0 = rho(ind);
end

