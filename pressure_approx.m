function p0 = pressure_approx(rho0)
%PRESSURE_APPROX 此处显示有关此函数的摘要
    load('P_Rho_model.mat');
    ind = binarySearch(rho, rho0);
    p0 = p(ind);
end

