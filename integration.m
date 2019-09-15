clear ; close all; clc

C = 0.85;
A = pi * 0.7^2;
volume = 500 * pi * 5^2;

load('Rho_P_model.mat');
for x = 0.021:0.0001:0.022
    sum = 0;
    for p1 = 100:0.0001:150
        ind = floor(p1 * 100) + 1;
        deriv = (rho(ind + 1) - rho(ind)) / (10^3 * 0.01);
        sum = sum + volume * deriv * 0.0001 * 10^3 / (0.8711 * C * A * sqrt(2 * 10^3 * (160 - p1) / 0.8711) * x / (x + 10) - 0.85 * 0.44);
    end
    fprintf('x=%f sum=%f\n',x, sum);
end
 