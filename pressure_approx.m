function p0 = pressure_approx(rho0)
%PRESSURE_APPROX �˴���ʾ�йش˺�����ժҪ
    load('P_Rho_model.mat');
    ind = binarySearch(rho, rho0);
    p0 = p(ind);
end

